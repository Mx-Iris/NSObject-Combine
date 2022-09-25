import Combine
import ObjectiveC
import Foundation

public class CombineWrapper<Base> {
    public let base: Base

    public init(base: Base) {
        self.base = base
    }
}

public protocol HasCancellable {
    associatedtype Base
    static var combine: CombineWrapper<Base>.Type { get set }
    var combine: CombineWrapper<Base> { get set }
}

public extension HasCancellable {
    static var combine: CombineWrapper<Self>.Type {
        get { CombineWrapper<Self>.self }
        set {}
    }

    var combine: CombineWrapper<Self> {
        get { .init(base: self) }
        set {}
    }
}

extension NSObject: HasCancellable {}

private var cancellablesKey: Void = ()

extension CombineWrapper where Base: AnyObject {
    func synchronizedSubscriptions<T>(_ action: () -> T) -> T {
        objc_sync_enter(base)
        let result = action()
        objc_sync_exit(base)
        return result
    }
}

extension CombineWrapper where Base: AnyObject {
    private class AnyCancellableWrapper {
        var value: Set<AnyCancellable>
        init(value: Set<AnyCancellable> = .init()) {
            self.value = value
        }
    }

    public var cancellables: Set<AnyCancellable> {
        get {
            return synchronizedSubscriptions {
                if let subscriptions = objc_getAssociatedObject(base, &cancellablesKey) as? AnyCancellableWrapper {
                    return subscriptions.value
                }
                let subscriptions = AnyCancellableWrapper()
                objc_setAssociatedObject(base, &cancellablesKey, subscriptions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return subscriptions.value
            }
        }

        set {
            synchronizedSubscriptions {
                objc_setAssociatedObject(base, &cancellablesKey, AnyCancellableWrapper(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
