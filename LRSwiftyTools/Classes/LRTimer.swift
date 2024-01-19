import UIKit
open class LRTimer: NSObject {
    public var timer: Timer?
    fileprivate weak var aTarget: AnyObject?
    fileprivate var aSelector: Selector?
    public class func scheduledTimer(timeInterval ti: TimeInterval, target aTarget: AnyObject, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> LRTimer {
        let timer = LRTimer()
        timer.aTarget = aTarget
        timer.aSelector = aSelector
        timer.timer = Timer.scheduledTimer(timeInterval: ti, target: timer, selector: #selector(LRTimer._timerRun), userInfo: userInfo, repeats: yesOrNo)
        return timer
    }
    public func fire() {
        timer?.fire()
    }
    public func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    public func pauseTimer() {
        timer?.fireDate = .distantFuture
    }
    public func begainTimer() {
        timer?.fireDate = Date()
    }
    @objc func _timerRun() {
        _ = aTarget?.perform(aSelector)
    }
    deinit {
        print("deinit")
    }
}
