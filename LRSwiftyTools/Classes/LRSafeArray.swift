import Foundation
import UIKit
@objc public extension NSArray {
    @objc func safeObjectAtIndex(_ index: Int) -> Any? {
        if index < self.count && index >= 0 {
            return self[index]
        } else {
            return nil
        }
    }    
}
public extension Array {
    func safeObjectAtIndex(_ index: Int) -> Element? {
        if index < self.count && index >= 0 {
            return self[index]
        } else {
            return nil
        }
    }
    @discardableResult
    mutating func safeRemoveAt(_ index: Int) -> Bool {
        if index < self.count, index >= 0 {
            self.remove(at: index)
            return true
        }
        return false
    }
}
public extension Array {
    func limit(_ index: Int) -> Self {
        if self.count <= index { return self }
        let slice = self[0 ..< index]
        return Array(slice)
    }
    func hollow() -> Self {
        if self.count <= 2 { return self }
        return [self[0], self[self.count - 1]]
    }
    mutating func hollowed() {
        if self.count <= 2 { return }
        self = [self[0], self[self.count - 1]]
    }
}
