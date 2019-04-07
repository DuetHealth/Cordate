import Foundation

public extension ManualDateField {

    struct Order {
        public static let dayMonthYear = Order((.day, .month, .year))
        public static let monthDayYear = Order((.month, .day, .year))
        public static let yearDayMonth = Order((.year, .day, .month))
        public static let yearMonthDay = Order((.year, .month, .day))

        let components: (Calendar.Component, Calendar.Component, Calendar.Component)

        private init(_ components: (Calendar.Component, Calendar.Component, Calendar.Component)) {
            self.components = components
        }

    }

}
