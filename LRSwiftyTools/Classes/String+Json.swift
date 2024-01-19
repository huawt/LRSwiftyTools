import Foundation
public extension Dictionary {
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
     }
}
public extension String {
    func toDictionary() -> [String : Any] {
        var result: [String : Any] = [:]
        guard !self.isEmpty else { return result }
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf, options: .mutableContainers) as? [String : Any] ?? [:] {
            result = dic
        }
        return result
    }
}
