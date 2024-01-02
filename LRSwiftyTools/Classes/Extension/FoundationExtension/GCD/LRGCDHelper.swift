
import Foundation
import Dispatch

/// 延迟几秒
public func cmAfter(delayTime: TimeInterval, doSomeThing: @escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime) {
        doSomeThing()
    }
}


public func cmMainThread (doSomeThing: @escaping ()->()) {
    
    DispatchQueue.main.async {
        doSomeThing()
    }
}

public func cmSafeMainThread (doSomeThing: @escaping ()->()) {
    if  Thread.isMainThread {
        doSomeThing()
    } else {
        DispatchQueue.main.async {
            doSomeThing()
        }
    }
}

public func cmSafeSyncMainThread (doSomeThing: @escaping ()->()) {
    if  Thread.isMainThread {
        doSomeThing()
    } else {
        DispatchQueue.main.sync {
            doSomeThing()
        }
    }
}

public func cmSubThread(doSomeThing: @escaping ()->()) {
    
    DispatchQueue.global().async {
        doSomeThing()
    }
}

public func cmSubThread(delayTime: TimeInterval, doSomeThing: @escaping ()->()) {
    
    DispatchQueue.global().asyncAfter(deadline: .now() + delayTime) {
        doSomeThing()
    }
}

public class GCDTool: NSObject {

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
