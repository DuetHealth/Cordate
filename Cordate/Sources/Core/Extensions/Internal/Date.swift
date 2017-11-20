import Foundation

extension Date {

    init?(day: Int, month: Int, year: Int) {
        guard let date = Calendar(identifier: .gregorian).date(from: DateComponents {
            $0.day = day
            $0.month = month
            $0.year = year
        }) else { return nil }
        self = date
    }

}


