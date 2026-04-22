import Foundation
import UIKit

public struct CalendarStyle: Sendable {

    static func textColor(for color: UIColor) -> UIColor? {
        guard color != .clear else { return .black }
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        guard color.getRed(&red, green: &green, blue: &blue, alpha: nil) else { return nil }
        let max = CGFloat(UInt8.max)
        let redByte = UInt8(max * red * 0.299)
        let greenByte = UInt8(max * green * 0.587)
        let blueByte = UInt8(max * blue * 0.114)
        if redByte + greenByte + blueByte > 186 {
            return .black
        }
        return .white
    }

    public enum ButtonConfiguration: Sendable {
        case none
        case confirmationOnly
        case all
    }

    public var unselectedBackgroundColor = UIColor(white: 0.95, alpha: 1)
    public var unselectedTextColor = UIColor?.none
    public var selectedTextColor = UIColor?.none
    public var selectedBackgroundColor = UIColor?.none
    public var headerTextColor = UIColor.black
    public var enabledCalendarModeButtonColor = UIColor?.none
    public var disabledCalendarModeButtonColor = UIColor(white: 0.9, alpha: 1)
    public var calendarModeButtonFont = UIFont.boldSystemFont(ofSize: 16)
    public var titleFont = UIFont.boldSystemFont(ofSize: 18)
    public var calendarHeaderFont = UIFont.boldSystemFont(ofSize: 14)
    public var calendarFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var usesHaptics: Bool = true
    public var buttonConfiguration = ButtonConfiguration.all

    public init() { }

}
