
import Foundation

public func countDown(with time:Int,countDownClosure:@escaping (()->Void),stepClosure:@escaping ((String,Int)->Void)) -> DispatchSourceTimer{
    var timeout: Int = time
    let queue = DispatchQueue.global()
    let source = DispatchSource.makeTimerSource(flags: [], queue: queue)
    source.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(100))
    source.setEventHandler{
        if timeout <= 0 {
            source.cancel()
            DispatchQueue.main.async {
                // 执行操作，例如更新倒计时按钮UI
                countDownClosure()
            }
        } else {
            let minute = timeout / 60
            let second = timeout % 60
            DispatchQueue.main.async {
                // 执行操作，例如更新倒计时按钮UI
                stepClosure(String.init(format: "%02d:%02d", minute,second),timeout)
            }
        }
        timeout -= 1
    }
    source.resume()
    return source
}

public func orderCountDown(with time:Int,countDownClosure:@escaping ((String)->Void),stepClosure:@escaping ((String,Int,String)->Void),tradId:String) -> DispatchSourceTimer {
    var timeout: Int = time
    let queue = DispatchQueue.global()
    let source = DispatchSource.makeTimerSource(flags: [], queue: queue)
    source.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(100))
    source.setEventHandler{
        if timeout <= 0 {
            source.cancel()
            DispatchQueue.main.async {
                // 执行操作，例如更新倒计时按钮UI
                countDownClosure(tradId)
            }
        } else {
            let minute = timeout / 60
            let second = timeout % 60
            DispatchQueue.main.async {
                // 执行操作，例如更新倒计时按钮UI
                stepClosure(String.init(format: "%02d:%02d", minute,second),timeout,tradId)
            }
        }
        timeout -= 1
    }
    source.resume()
    return source
}
