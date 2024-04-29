import UIKit
@objcMembers
open class LRTimer: NSObject {
    fileprivate var timer: Timer?
    fileprivate weak var aTarget: AnyObject?
    fileprivate var aSelector: Selector?
    @objc public class func scheduledTimer(timeInterval ti: TimeInterval, target aTarget: AnyObject, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> LRTimer {
        let timer = LRTimer()
        timer.aTarget = aTarget
        timer.aSelector = aSelector
        timer.timer = Timer.scheduledTimer(timeInterval: ti, target: timer, selector: #selector(LRTimer._timerRun), userInfo: userInfo, repeats: yesOrNo)
        return timer
    }
    @objc public func fire() {
        timer?.fire()
    }
    @objc public func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    @objc public func pauseTimer() {
        timer?.fireDate = .distantFuture
    }
    @objc public func begainTimer() {
        timer?.fireDate = Date()
    }
    @objc func _timerRun() {
        _ = aTarget?.perform(aSelector)
    }
    deinit {
        print("deinit")
    }
}
