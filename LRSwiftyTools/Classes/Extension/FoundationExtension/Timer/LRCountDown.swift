
/**
 LRCountDown为倒计时天数、时、分、秒，实时返回字符串形式的天、时、分、秒
 LRCountDown采用 GCD 定时器，不会造成内存泄漏
 若需要后台运行，需要在 target 中设置 capabilities 的 background modes 勾选 Audio，AirPlay，Picture in Picture
 不设置仍会正常执行，间隔的秒数将快速执行跳过
 为用最小的开销使用定时器，请使用如下方式使用定时器：
 1. 在类中初始化 LRCountDown，并需要设置回调函数
 2. 如果在自定义类中，需在deinit析构函数中 调用 stop()
 3. 如果在控制器中，在viewWillAppear函数中 调用 resume()，
 在viewWillDisappear函数中 调用 suspend（）
 4. 在使用需要开启的时候 使用 start(with endDate: String)
 
 // 详情请看 Demo
 */


import Foundation


fileprivate struct LREndDate {
    var day: Int?
    var hour: Int?
    var minute: Int?
    var second: Int?
}

public class LRCountDown: NSObject {
    /// 要计算的时间
    fileprivate var currentDate: LREndDate?
    /// 定时器
    fileprivate var timer: DispatchSourceTimer?
    /// 开始时间
    fileprivate var startDateString: String? = nil
    /// 结束时间
    fileprivate var endDateString: String? = nil
    /// 回调 计算好的 天、时、分、秒
    public var countDown: ((_ day: String, _ hour: String, _ minute: String, _ second: String) -> Void)?
    /// 开始启动定时器，需传入结束时间
    public func start(with startDate: String?, end endDate: String) { startDateString = startDate ; endDateString = endDate ; createTimer() }
    /// 启用定时器
    public func resume() { if endDateString == nil { return } ; createTimer() }
    /// 暂停定时器
    public func suspend() { stop() }
    /// 停止定时器
    public func stop() { guard let timer = timer else { return } ; timer.cancel() }
    /// 创建定时器
    fileprivate func createTimer() {
        guard let endDateString = endDateString else { print("没有设置开始时间") ; return }
        guard let countDown = countDown else { print("没有设置回调函数") ; return }
        // 将 endDateString 转化成时间戳
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate: Date
        if let startDateString = startDateString { startDate = dateFormatter.date(from: startDateString)! }
        else { startDate = Date() }
        let endDate = dateFormatter.date(from: endDateString)
        var timeCount = endDate!.timeIntervalSince(startDate)
        // 当时间小于当前时间
        if timeCount <= 0 { countDown("00", "00", "00", "00") ; return }
        // 设置计算时间的格式
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let component = calendar.dateComponents(unit, from: Date.init(), to: endDate!)
        currentDate = LREndDate(day: component.day, hour: component.hour, minute: component.minute, second: component.second)
        // 设置定时器
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer!.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1))
        // 定时器的回调事件
        timer!.setEventHandler { [unowned self] in self.calculateCurrentDate() ; timeCount -= 1 }
        timer!.resume()
    }
    /// 定时器计时事件
    fileprivate func calculateCurrentDate() {
        // 解包
        guard let countDown = countDown else { return }
        // 在创建定时器之前已经判断过timeCount <= 0, 保证了timeCount > 0, 此时这里不用判断
        // 计算显示时间
        currentDate!.second! -= 1
        if currentDate!.second! == -1 { currentDate!.second! = 59 ; currentDate!.minute! -= 1
            if currentDate!.minute! == -1 { currentDate!.minute! = 59 ; currentDate!.hour! -= 1
                if currentDate!.hour! == -1 { currentDate!.hour! = 23 ; currentDate!.day! -= 1 }
            }
        }
        if  currentDate!.second! == 0
            &&  currentDate!.minute! == 0
            && currentDate!.hour! == 0
            && currentDate!.day! == 0 {
            timer!.cancel()
            DispatchQueue.main.async(execute: { countDown("0", "00", "00", "00") })
            return
        }
        // 主线程更新返回数据
        DispatchQueue.main.async(execute: { [unowned self ] in
            if let day = self.currentDate?.day, let hour = self.currentDate?.hour, let minute = self.currentDate?.minute, let second = self.currentDate?.second{
                countDown(String(format: "%02d", day),
                          String(format: "%02d", hour),
                          String(format: "%02d", minute),
                          String(format: "%02d", second))
            }else{
                DispatchQueue.main.async(execute: { countDown("0", "00", "00", "00") })
            }
            
        })
    }
    deinit { timer?.cancel() }
}

