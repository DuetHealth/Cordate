import Foundation
import UIKit

public struct CalendarStyle {

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

    /// Drives which buttons are shown on the calendar.
    public enum ButtonConfiguration {

        /// The calendar shows no buttons and produces values continuously.
        case none

        /// The calendar shows a confirmation button and only produces a value when it is pressed.
        case confirmationOnly

        /// The calendar shows both a confirmation button and a clear button. 
        case all

    }

    /// The background color for unselected date components.
    public var unselectedBackgroundColor = UIColor(white: 0.95, alpha: 1)

    /// The text color for unselected date components.
    ///
    /// When this value is `nil`, the calendar will choose either white or black text depending on
    /// the intensity of the current background color.
    public var unselectedTextColor = UIColor?.none

    /// The text color for selected date components.
    ///
    /// When this value is `nil`, the calendar will choose either white or black text depending on
    /// the intensity of the current background color.
    public var selectedTextColor = UIColor?.none

    /// The background color for selected date components.
    ///
    /// When this value is `nil`, the calendar will use its view's tint color.
    public var selectedBackgroundColor = UIColor?.none

    /// The text color for the day-mode header.
    public var headerTextColor = UIColor.black

    /// The tint color for the calendar mode buttons in the enabled state.
    ///
    /// When this value is `nil`, the calendar will use its view's tint color.
    public var enabledCalendarModeButtonColor = UIColor?.none

    /// The tint color for the calendar mode buttons in the disabled state.
    public var disabledCalendarModeButtonColor = UIColor(white: 0.9, alpha: 1)

    /// The font for the calendar mode buttons.
    public var calendarModeButtonFont = UIFont.boldSystemFont(ofSize: 16)

    public var titleFont = UIFont.boldSystemFont(ofSize: 18)

    public var calendarHeaderFont = UIFont.boldSystemFont(ofSize: 14)

    /// The font for the calendar controls.
    public var calendarFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)

    private var _usesHaptics: Bool = true

    /// Controls whether selection events trigger haptic feedback.
    @available(iOS 10.0, *)
    public var usesHaptics: Bool {
        get { return _usesHaptics }
        set { _usesHaptics = newValue }
    }

    /// Controls which controls are provided by the calendar.
    public var buttonConfiguration = ButtonConfiguration.all

    public init() { }

}
