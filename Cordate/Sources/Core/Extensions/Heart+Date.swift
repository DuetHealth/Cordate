import Foundation

extension Date: HeartCompatible { }

public extension Heart where Base == Date {

    /// Returns the numerical representation of the day of the date.
    public var day: Int {
        return Calendar(identifier: .gregorian).component(.day, from: base)
    }

    /// Returns the numerical representation of the month of the date.
    public var month: Int {
        return Calendar(identifier: .gregorian).component(.month, from: base)
    }

    /// Returns the numerical representation of the year of the date.
    public var year: Int {
        return Calendar(identifier: .gregorian).component(.year, from: base)
    }

    /// Returns the date as a local date calculated by shifting according to the current time zone.
    public var local: Date {
        let offset = TimeInterval(TimeZone.current.secondsFromGMT(for: base))
        return Date(timeInterval: offset, since: base)
    }

}
