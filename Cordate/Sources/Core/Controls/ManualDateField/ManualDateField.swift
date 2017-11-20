import Foundation
import UIKit

@objc public protocol ManualDateFieldDelegate: UITextFieldDelegate {
    @objc optional func dateField(_ dateField: ManualDateField, didProduceDate date: Date?)
}

public class ManualDateField: UITextField {

    fileprivate class InternalDelegate: NSObject, UITextFieldDelegate {

        weak var forwardedDelegate = UITextFieldDelegate?.none

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let field = textField as? ManualDateField else { return true }
            let delegatePermitsChanging = forwardedDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
            let isDeleting = string == ""
            return !field.isAtLimit || isDeleting && delegatePermitsChanging
        }

        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return forwardedDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            forwardedDelegate?.textFieldDidBeginEditing?(textField)
        }

        public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            return forwardedDelegate?.textFieldShouldEndEditing?(textField) ?? true
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            forwardedDelegate?.textFieldDidEndEditing?(textField)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return forwardedDelegate?.textFieldShouldReturn?(textField) ?? true
        }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            return forwardedDelegate?.textFieldShouldClear?(textField) ?? true
        }

    }

    public let order: Order
    public let separator: Separator
    public let format: Format
    private let internalDelegate = InternalDelegate()
    private let formatter = DateFormatter()

    public var placeholderColor = UIColor.lightGray

    public private(set) var date = Date?.none

    public var minimumDate = Date.distantPast
    public var maximumDate = Date.distantFuture

    /// Controls whether the field will attempt to produce a date whenever the text changes or
    /// only when the input matches the format.
    ///
    /// The default value of this is `false`.
    public var shouldEagerlyProduceDate = false

    public override var intrinsicContentSize: CGSize {
        return generateDrawingRepresentation().size()
    }

    public weak var dateDelegate: ManualDateFieldDelegate? {
        didSet { internalDelegate.forwardedDelegate = dateDelegate }
    }

    public override weak var delegate: UITextFieldDelegate? {
        willSet {
            if newValue is InternalDelegate { return }
            print("\(type(of: self)).\(#function):\(#line) WARN - setting UITextField.delegate directly! Prefer ManualDateField.dataDelegate.")
        }
    }

    public var rawDate: String? {
        return text.map(formatText)
    }

    private var isAtLimit: Bool {
        return text.map(formatText)?.count == formatter.dateFormat.count
    }

    public init(order: Order = .monthDayYear, separator: Separator = .slash, format: Format = Format(yearFormat: .long)) {
        self.order = order
        self.separator = separator
        self.format = format
        super.init(frame: .zero)
        formatter.dateFormat = format.dateFormat(separator: separator, orderedBy: order)
        placeholder = formatter.dateFormat.uppercased()
        keyboardType = .numberPad
        addTarget(self, action: #selector(produceDate), for: .editingChanged)
        delegate = internalDelegate
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }

    public override func copy() -> Any {
        return text.map(formatText) ?? ""
    }

    public override func drawText(in rect: CGRect) {
        let drawingRepresentation = generateDrawingRepresentation()
        let heightInset = (rect.size.height - drawingRepresentation.size().height) / 2
        drawingRepresentation.draw(in: rect.insetBy(dx: 0, dy: heightInset))
    }

    @objc public func setDate(_ date: Date?) {
        guard self.date != date else { return }
        self.date = date
        text = date.map(formatter.string(from:))?.replacingOccurrences(of: separator.rawValue, with: "")
        setNeedsDisplay()
    }

    public override func drawPlaceholder(in rect: CGRect) { }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(select(_:)), #selector(selectAll(_:)): return true
        case #selector(copy(_:)), #selector(cut(_:)): return true
        default: return false
        }
    }

    public override func closestPosition(to point: CGPoint) -> UITextPosition? {
        return position(from: beginningOfDocument, offset: text?.count ?? 0)
    }

    private func generateDrawingRepresentation() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        let font = self.font ?? .systemFont(ofSize: UIFont.systemFontSize)
        let baseAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: font,
                                                             .foregroundColor: placeholderColor,
                                                             .paragraphStyle: paragraphStyle]
        let textToDraw = (rawDate ?? "") + formatter.dateFormat.localizedUppercase.dropFirst(rawDate?.count ?? 0)
        let drawingRepresentation = NSMutableAttributedString(string: textToDraw, attributes: baseAttributes)
        drawingRepresentation.addAttribute(.foregroundColor, value: textColor ?? .black, range: NSRange(location: 0, length: rawDate?.count ?? 0))

        textToDraw.occurrences(of: separator.rawValue).forEach { (index: Int) in
            drawingRepresentation.addAttribute(.font, value: self.font!, range: NSRange(location: index, length: 1))
        }

        formatter.dateFormat.occurrences(of: separator.rawValue)
            .map { (integerIndex: Int) -> NSRange in
                let index = formatter.dateFormat.index(formatter.dateFormat.startIndex, offsetBy: integerIndex)
                return NSRange(index..<formatter.dateFormat.index(index, offsetBy: 1), in: formatter.dateFormat)
            }.forEach {
                drawingRepresentation.addAttribute(.foregroundColor, value: textColor ?? .black, range: $0)
                drawingRepresentation.addAttribute(.kern, value: 4, range: NSRange(location: $0.location - 1, length: 2))
        }

        return drawingRepresentation
    }

    @objc private func produceDate() {
        defer { dateDelegate?.dateField?(self, didProduceDate: self.date) }
        guard let formattedText = text.map(formatText),
        shouldEagerlyProduceDate || formattedText.count == formatter.dateFormat.count,
        let date = formatter.date(from: formattedText) else {
            self.date = nil
            return
        }
        self.date = date < minimumDate || date > maximumDate ? nil : date
    }

    private func formatText(_ text: String) -> String {
        guard text.count > 0 else { return "" }
        var copy = text
        formatter.dateFormat.occurrences(of: separator.rawValue)
            .filter { $0 <= text.count }
            .forEach {
                copy.insert(contentsOf: separator.rawValue, at: copy.index(copy.startIndex, offsetBy: $0))
            }
        return copy
    }

}
