import Foundation
class WeakSet<T: AnyObject>: Sequence, ExpressibleByArrayLiteral, CustomStringConvertible, CustomDebugStringConvertible {
	private var objects = NSHashTable<T>.weakObjects()
    init(_ objects: [T]) {
		for object in objects {
			insert(object)
		}
	}
    required convenience init(arrayLiteral elements: T...) {
		self.init(elements)
	}
    var allObjects: [T] {
		return objects.allObjects
	}
    var count: Int {
		return objects.count
	}
    var isEmpty: Bool {
		return objects.count == 0
	}
    func contains(_ object: T) -> Bool {
		return objects.contains(object)
	}
    func add(_ object: T) {
		objects.add(object)
	}
    func append(_ object: T) {
		objects.add(object)
	}
    func insert(_ object: T) {
		objects.add(object)
	}
    func delete(_ object: T) {
		objects.remove(object)
	}
    func remove(_ object: T) {
		objects.remove(object)
	}
    func clear() {
		objects.removeAllObjects()
	}
    func removeAll() {
		objects.removeAllObjects()
	}
    func makeIterator() -> AnyIterator<T> {
		let iterator = objects.objectEnumerator()
		return AnyIterator {
			iterator.nextObject() as? T
		}
	}
    var description: String {
		return objects.description
	}
    var debugDescription: String {
		return objects.debugDescription
	}
}
public protocol DispatchPool {
	associatedtype Observer: NSObjectProtocol
    func add(observer: Observer)
    func del(observer: Observer)
    func dispatch(selector: Selector, object1: Any?, object2: Any?)
}
open class Dispatcher<P: NSObjectProtocol>: NSObject, DispatchPool {
	fileprivate let mutex = NSLock()
    public override init() { }
	deinit {
		observers.removeAll()
	}
	private var observers = WeakSet<P>()
	open func add(observer: P) {
		mutex.lock()
		defer { mutex.unlock() }
		self.observers.add(observer)
	}
	open func del(observer: P) {
		mutex.lock()
		defer { mutex.unlock() }
		self.observers.remove(observer)
	}
	open func dispatch(selector: Selector, object1: Any?, object2: Any?) {
		let observers = self.observers.allObjects
		let work = {
			observers.forEach({ (observer) in
				guard observer.responds(to: selector) else {
					return
				}
				if let object2 = object2, let object1 = object1 {
					observer.perform(selector, with: object1, with: object2)
				} else if let object1 = object1 {
					observer.perform(selector, with: object1)
				} else {
					observer.perform(selector)
				}
			})
		}
		DispatchQueue.dispatchOnMain(work)
	}
}
public protocol Dispatchable: DispatchPool {
	associatedtype Ablity: NSObjectProtocol
    var dispatcher: Dispatcher<Ablity> { get }
}
extension Dispatchable {
	public func add(observer: Self.Ablity) {
		dispatcher.add(observer: observer)
	}
	public func del(observer: Self.Ablity) {
		dispatcher.del(observer: observer)
	}
	public func dispatch(selector: Selector, object1: Any? = nil, object2: Any? = nil) {
		dispatcher.dispatch(selector: selector, object1: object1, object2: object2)
	}
}
extension DispatchQueue {
	static func dispatchOnMain(_ work: @escaping (() -> Void)) {
		if Thread.isMainThread {
			work()
		} else {
			main.async(execute: work)
		}
	}
}
