import Foundation

public struct Heart<Base> {

    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }

}

public protocol HeartCompatible {
    associatedtype CompatibleType

    var heart: Heart<CompatibleType> { get }

}

extension HeartCompatible {

    public var heart: Heart<Self> {
        return Heart(self)
    }

}
