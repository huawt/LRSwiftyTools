import Foundation
fileprivate struct LREndDate {
    var day: Int?
    var hour: Int?
    var minute: Int?
    var second: Int?
}
public class LRCountDown: NSObject {
    fileprivate var currentDate: LREndDate?
    fileprivate var timer: DispatchSourceTimer?
    fileprivate var startDateString: String? = nil
    fileprivate var endDateString: String? = nil
    public var countDown: ((_ day: String, _ hour: String, _ minute: String, _ second: String) -> Void)?
    public func start(with startDate: String?, end endDate: String) { startDateString = startDate ; endDateString = endDate ; createTimer() }
    public func resume() { if endDateString == nil { return } ; createTimer() }
    public func suspend() { stop() }
    public func stop() { guard let timer = timer else { return } ; timer.cancel() }
    fileprivate func createTimer() {
        guard let endDateString = endDateString else { print("not set start time") ; return }
        guard let countDown = countDown else { print("not set callback") ; return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate: Date
        if let startDateString = startDateString { startDate = dateFormatter.date(from: startDateString)! }
        else { startDate = Date() }
        let endDate = dateFormatter.date(from: endDateString)
        var timeCount = endDate!.timeIntervalSince(startDate)
        if timeCount <= 0 { countDown("00", "00", "00", "00") ; return }
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let component = calendar.dateComponents(unit, from: Date.init(), to: endDate!)
        currentDate = LREndDate(day: component.day, hour: component.hour, minute: component.minute, second: component.second)
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer!.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1))
        timer!.setEventHandler { [unowned self] in self.calculateCurrentDate() ; timeCount -= 1 }
        timer!.resume()
    }
    fileprivate func calculateCurrentDate() {
        guard let countDown = countDown else { return }
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
