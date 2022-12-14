//
//  Array+Ext.swift
//  
//
//  Created by WinTer on 2022/6/3.
//

import Foundation

extension Array where Element: Hashable {
    var unique: [Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        return self.filter {
            uniq.insert($0).inserted
        }
    }
}

extension Array where Element: Any {
    func shuffle() -> Self {
        guard self.count > 1 else { return self }
        var temp = self
        var result: [Element] = []
        while result.count != self.count {
            let index = Int(arc4random_uniform(UInt32(temp.count)))
            let e = temp.remove(at: index)
            result.append(e)
        }
        return result
    }
}

extension Array {
    public mutating func removeFirst(_ k: Int) -> Self {
        if self.count < k {
            let array = self
            self.removeAll()
            return array
        } else {
            let array = self[0..<k]
            self.removeSubrange(0..<k)
            return Array(array)
        }
    }
}
