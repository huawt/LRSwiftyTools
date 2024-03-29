import Foundation
import AVFoundation
import AudioToolbox
import AVFAudio
@objc public enum LRAudioPlayState: Int {
    case failure
    case playing
    case stoped
    case finished
}
@objcMembers
open class LRAudioPlayer: NSObject {
    static let shared: LRAudioPlayer = LRAudioPlayer()
    private(set) var currentUrl: String?
    private(set) var playState: LRAudioPlayState = .finished
    fileprivate var player: AVPlayer?
    fileprivate var timeObserver: NSObjectProtocol?
    fileprivate var statusObserver: NSObjectProtocol?
    fileprivate var progress: ((_ progress: CGFloat)->Void)?
    fileprivate var completionHandler: ((_ state: LRAudioPlayState, _ msg: String?)->Void)?
    public func playAudio(_ urlString: String, progress: ((_ progress: CGFloat)->Void)?, completionHandler: ((_ state: LRAudioPlayState, _ msg: String?)->Void)?) {
        if let url = self.currentUrl, url != urlString {
            self.stopPlay()
        }
        LRAudioPlayer.changeAudioSession()
        self.progress = progress
        self.completionHandler = completionHandler
        self.currentUrl = urlString
        var audioUrl: URL?
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            audioUrl = URL(string: urlString)
        } else {
            audioUrl = URL(fileURLWithPath: urlString)
        }
        guard let url = audioUrl else { self.failureHandler(); return }
        let audioItem = AVPlayerItem(url: url)
        self.player = AVPlayer()
        self.player?.rate = 1
        self.player?.replaceCurrentItem(with: audioItem)
        self.addCurrentItemObserver()
    }
    public func stopPlay() {
        self.changePlayState(.stoped)
        self.completionHandler?(.stoped, "stop")
        self.clearSomething()
    }
    func clearSomething() {
        self.removeCurrentItemObserver()
        self.player?.pause()
        self.player = nil
        self.currentUrl = nil
        self.progress = nil
        self.completionHandler = nil
    }
    fileprivate func addCurrentItemObserver() {
        self.statusObserver = self.player?.currentItem?.observe(\.status, options: [.old, .new], changeHandler: { [weak self] (item, _) in
            switch item.status {
            case .unknown:
                self?.failureHandler()
            case .readyToPlay:
                self?.player?.play()
            case .failed:
                self?.failureHandler()
            @unknown default: break
            }
        })
        self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: {[weak self, weak player] time in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(player?.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
            let p = current / total
            self?.progress?(p)
            if p == 1 {
                self?.successHandler()
            } else {
                self?.changePlayState(.playing)
                self?.completionHandler?(.playing, "playing")
            }
        }) as? NSObjectProtocol
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    @objc fileprivate func playerDidEnd() {
        self.successHandler()
    }
    fileprivate func successHandler() {
        DispatchQueue.main.async { [weak self] in
            self?.progress?(1)
            self?.changePlayState(.finished)
            self?.completionHandler?(.finished, "finished")
            self?.clearSomething()
        }
    }
    fileprivate func removeCurrentItemObserver() {
        self.statusObserver = nil
        self.timeObserver = nil
        NotificationCenter.default.removeObserver(self)
    }
    fileprivate func failureHandler() {
        DispatchQueue.main.async { [weak self] in
            self?.progress?(0)
            self?.changePlayState(.failure)
            self?.completionHandler?(.failure, "failure")
            self?.clearSomething()
        }
    }
    fileprivate func changePlayState(_ state: LRAudioPlayState) {
        self.playState = state
    }
    deinit {
        self.removeCurrentItemObserver()
    }
}
extension LRAudioPlayer {
    class func changeAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions(rawValue: 41))
        try? AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
    }
}
