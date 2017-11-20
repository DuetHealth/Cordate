import Foundation
import UIKit

public class CalendarDataSource {

    public enum CalendarMode {
        case birthDate

        var range: (minimum: Date?, maximum: Date?) {
            switch self {
            case .birthDate:
                let maximum = Date().heart.local
                let minimum = Date(day: 1, month: 1, year: maximum.heart.year - 150)
                return (minimum, maximum)
            }
        }
    }

    public struct Common {

        private static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            return formatter
        }()

        public static var weekdays: [String] {
            return Common.formatter.shortWeekdaySymbols
        }

        public static var months: [String] {
            return Common.formatter.monthSymbols
        }

    }

    public enum Component {
        case day(month: Int, year: Int)
        case month(year: Int)
        case year
    }

    public var minimumDate: Date
    public var maximumDate: Date

    private var years: CountableClosedRange<Int> {
        return minimumDate.heart.year...maximumDate.heart.year
    }

    public init(minimumDate: Date? = nil, maximumDate: Date? = nil) {
        self.minimumDate = minimumDate ?? Date.distantPast
        self.maximumDate = maximumDate ?? Date.distantFuture
    }

    public convenience init(mode: CalendarMode) {
        let (minimum, maximum) = mode.range
        self.init(minimumDate: minimum, maximumDate: maximum)
    }

    public func numberOfOptions(for component: Component) -> Int {
        switch component {
        case .year: return years.count
        case .month: return Common.months.count
        case .day(let month, let year):
            let firstDay = Date(day: 1, month: month, year: year)!
            return Calendar(identifier: .gregorian).range(of: .day, in: .month, for: firstDay)!.count
        }
    }

    public func monthIsAvailable(_ month: Int, inYear year: Int) -> Bool {
        switch year {
        case minimumDate.heart.year: return month >= minimumDate.heart.month
        case maximumDate.heart.year: return month <= maximumDate.heart.month
        default: return true
        }
    }

    public func dayIsAvailable(_ day: Int, inMonth month: Int, year: Int) -> Bool {
        switch (month, year) {
        case (minimumDate.heart.month, minimumDate.heart.year): return day >= minimumDate.heart.day
        case (maximumDate.heart.month, maximumDate.heart.year): return day <= maximumDate.heart.day
        default: return true
        }
    }

    public func offsetOfMonth(_ month: Int, in year: Int) -> Int {
        let firstDay = Date(day: 1, month: month, year: year)!
        return Calendar(identifier: .gregorian).component(.weekday, from: firstDay) - 1
    }

    public func yearAtIndex(_ index: Int) -> Int {
        return years[years.index(years.startIndex, offsetBy: index)]
    }

    public func indexOfYear(_ year: Int) -> Int? {
        return Array(years).index(of: year)
    }

    public func stringFromYear(_ year: Int) -> String {
        let base = "\(year)"
        return (0..<(4 - Int(base.count))).reduce(base, { (string, next) in "0" + string })
    }

}
