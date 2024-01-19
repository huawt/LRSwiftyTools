import Foundation
import Dispatch
public func LRMainAfter(delayTime: TimeInterval, doSomeThing: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime) {
        doSomeThing()
    }
}
public func LRMainThread (doSomeThing: @escaping ()->()) {
    if  Thread.isMainThread {
        doSomeThing()
    } else {
        DispatchQueue.main.async {
            doSomeThing()
        }
    }
}
public func LRSyncMainThread (doSomeThing: @escaping ()->()) {
    if  Thread.isMainThread {
        doSomeThing()
    } else {
        DispatchQueue.main.sync {
            doSomeThing()
        }
    }
}
public func LRSubThread(doSomeThing: @escaping ()->()) {
    DispatchQueue.global().async {
        doSomeThing()
    }
}
public func LRSubThread(delayTime: TimeInterval, doSomeThing: @escaping ()->()) {
    DispatchQueue.global().asyncAfter(deadline: .now() + delayTime) {
        doSomeThing()
    }
}
open class GCDTool: NSObject {
    public typealias GCDTask = (_ cancel: Bool) -> ()
    @discardableResult
    public static func gcdDelay(_ time: TimeInterval, task: @escaping () -> ()) -> GCDTask?{
        func dispatch_later(block: @escaping () -> ()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (() -> Void)? = task
        var result: GCDTask?
        let delayedClosure: GCDTask = {
            cancel in
            if let closure = closure {
                if !cancel {
                    DispatchQueue.main.async(execute: closure)
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            if let result = result {
                result(false)
            }
        }
        return result
    }
    public static func gcdCancel(_ task: GCDTask?) {
        task?(true)
    }
}
