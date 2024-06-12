import Foundation
import LRSwiftyTools

@objc protocol DispatchExampleProtocol: NSObjectProtocol {
    @objc  optional func example()
}
class DispatchExample: NSObject, Dispatchable {
    static let example = DispatchExample()
    var dispatcher = Dispatcher<DispatchExampleProtocol>()
    func test() {
        self.dispatch(selector: #selector(DispatchExampleProtocol.example))
    }
}

