import Foundation

extension Int {

    static func allEqual(_ values: Int...) -> Bool {
        guard values.count > 1 else { return true }
        for value in values.dropFirst() {
            if value != values.first! { return false }
        }
        return true
    }

}
