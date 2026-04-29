import Foundation

public struct Heart<Base>: Sendable where Base: Sendable {

    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }

}

public protocol HeartCompatible {
    associatedtype CompatibleType: Sendable

    var heart: Heart<CompatibleType> { get }

}

extension HeartCompatible where Self: Sendable {

    public var heart: Heart<Self> {
        return Heart(self)
    }

}
