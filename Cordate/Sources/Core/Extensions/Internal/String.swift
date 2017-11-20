import Foundation

extension String {

    func occurrences(of string: String) -> [Int] {
        return enumerated()
            .filter { String($0.element) == string }
            .map { $0.offset }
    }

    func occurrences(of string: String) -> [String.Index] {
        return string.enumerated()
            .filter { String($0.element) == string }
            .map { string.index(string.startIndex, offsetBy: $0.offset) }
    }

}
