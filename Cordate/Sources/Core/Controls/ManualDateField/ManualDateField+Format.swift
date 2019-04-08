import Foundation

public extension ManualDateField {
    
    struct Format {
        
        enum Day: String {
            case `default` = "dd"
        }
        
        enum Month: String {
            case `default` = "MM"
        }
        
        public enum Year: String {
            case short = "yy"
            case long = "yyyy"
        }
        
        let dayFormat = Day.default
        let monthFormat = Month.default
        let yearFormat: Year
        
        public init(yearFormat: Year) {
            self.yearFormat = yearFormat
        }
        
        func dateFormat(separator: Separator, orderedBy order: Order) -> String {
            let selectFormat: (Calendar.Component) -> String = { component in
                switch component {
                case .day: return self.dayFormat.rawValue
                case .month: return self.monthFormat.rawValue
                case .year: return self.yearFormat.rawValue
                default: return ""
                }
            }
            let components = order.components
            return "\(selectFormat(components.0))\(separator.rawValue)\(selectFormat(components.1))\(separator.rawValue)\(selectFormat(components.2))"
        }
        
    }
    
}

