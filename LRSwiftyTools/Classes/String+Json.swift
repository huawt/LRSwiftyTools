//
//  String+Json.swift
//  
//
//  Created by huawt on 2022/6/28.
//

import Foundation

// MARK: 字典转字符串
extension Dictionary {
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

// MARK: 字符串转字典
extension String {
    func toDictionary() -> [String : Any] {
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf, options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    }
}
