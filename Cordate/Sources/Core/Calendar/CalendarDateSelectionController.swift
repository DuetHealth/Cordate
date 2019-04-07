import Foundation
import UIKit

/// Adopters of the 'CalendarDateSelectionControllerDelegate` respond to events triggered by user
/// interaction with the calendar.
@objc public protocol CalendarDateSelectionControllerDelegate: UICollectionViewDelegate {

    /// Called by the calendar when a user cleared the date.
    @objc optional func calendarControllerClearedDate(_ controller: CalendarDateSelectionController)

    /// Called by calendar when a user selects a date.
    @objc optional func calendarController(_ controller: CalendarDateSelectionController, didSelectDate date: Date)

}

public class CalendarDateSelectionController: UIViewController {

    private class EmptyCell: UICollectionViewCell { }

    private static let reuseIdentifier = "com.Cordate.calendar"

    /// Returns the title shown at the top of the calendar.
    public let calendarTitle: String?

    /// Returns the data source driving the calendar.
    public let dataSource: CalendarDataSource

    /// Returns the view which renders the calendar components.
    public let calendarView: UICollectionView

    /// Returns the layout object which drives the calendar layout.
    public let calendarLayout = CalendarLayout()

    private let titleLabel = UILabel()
    private let calendarHeader = UIStackView()
    private let yearButton = UIButton(type: .system)
    private let monthButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)

    /// The currently-selected date.
    @objc dynamic public var date = Date?.none {
        didSet { confirmButton.isEnabled = date != nil }
    }

    /// The style collection for the calendar.
    public var style = CalendarStyle() {
        didSet { applyStyle() }
    }

    public lazy override var presentationController: UIPresentationController? = {
        return CalendarPresentationController(presentedViewController: self, presenting: nil)
    }()

    /// The delegate which receives events from the calendar.
    public weak var delegate = CalendarDateSelectionControllerDelegate?.none

    private var currentComponent = CalendarDataSource.Component.year {
        didSet {
            switch currentComponent {
            case .day:
                yearButton.isEnabled = true
                monthButton.isEnabled = true
            case .month:
                yearButton.isEnabled = true
                monthButton.isEnabled = false
            case .year:
                yearButton.isEnabled = true
                monthButton.isEnabled = false
            }
        }
    }

    private var selectedYear = Int?.none {
        didSet { selectedDay = nil }
    }

    private var selectedMonth = Int?.none {
        didSet { selectedDay = nil }
    }
    
    private var selectedDay = Int?.none

    /// Performs an initial layout pass in viewDidLayoutSubviews which prepares the collection view's
    /// layout and, if applicable, scrolls to the selected year.
    private var hasLaidOutOnce = false

    public init(dataSource: CalendarDataSource = CalendarDataSource(), title: String? = nil, initialDate: Date? = nil) {
        self.calendarTitle = title
        self.dataSource = dataSource
        date = initialDate
        selectedDay = date?.heart.day
        selectedMonth = date?.heart.month
        selectedYear = date?.heart.year
        calendarView = UICollectionView(frame: .zero, collectionViewLayout: calendarLayout)
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = CGSize(width: 325, height: 0)
        transitioningDelegate = self
        modalPresentationStyle = .custom
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollsToTop = false
        calendarView.register(DayCell.self)
        calendarView.register(ComponentCell.self)
        calendarView.register(EmptyCell.self)

        switch (selectedMonth, selectedYear) {
        case (.some(let month), .some(let year)):
            currentComponent = .day(month: month, year: year)
            monthButton.setTitle(type(of: dataSource).Common.months[month - 1], for: .normal)
            yearButton.setTitle(dataSource.stringFromYear(year), for: .normal)
        case (.none, .some(let year)):
            currentComponent = .month(year: year)
            yearButton.setTitle(dataSource.stringFromYear(year), for: .normal)
        default: currentComponent = .year
        }
        calendarLayout.setLayoutProperties(for: currentComponent)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = calendarTitle
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])

        yearButton.translatesAutoresizingMaskIntoConstraints = false
        yearButton.contentHorizontalAlignment = .left
        yearButton.isEnabled = date != nil
        view.addSubview(yearButton)
        NSLayoutConstraint.activate([
            yearButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            yearButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            yearButton.heightAnchor.constraint(equalToConstant: 44),
            yearButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])

        monthButton.translatesAutoresizingMaskIntoConstraints = false
        monthButton.contentHorizontalAlignment = .right
        monthButton.isEnabled = date != nil
        view.addSubview(monthButton)
        NSLayoutConstraint.activate([
            monthButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            monthButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            yearButton.heightAnchor.constraint(equalToConstant: 44),
            yearButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])

        type(of: dataSource).Common.weekdays.map {
            let label = UILabel()
            label.textAlignment = .center
            label.text = $0
            return label
        }.forEach(calendarHeader.addArrangedSubview)
        calendarHeader.translatesAutoresizingMaskIntoConstraints = false
        calendarHeader.distribution = .fillEqually
        calendarHeader.alpha = date != nil ? 1 : 0
        view.addSubview(calendarHeader)
        NSLayoutConstraint.activate([
            calendarHeader.topAnchor.constraint(equalTo: yearButton.bottomAnchor, constant: 8),
            calendarHeader.topAnchor.constraint(equalTo: monthButton.bottomAnchor, constant: 8),
            calendarHeader.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            calendarHeader.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
        ])

        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = UIColor.white
        calendarView.showsVerticalScrollIndicator = false
        calendarView.showsHorizontalScrollIndicator = false
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarHeader.bottomAnchor, constant: 8),
            calendarView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            calendarView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            calendarView.heightAnchor.constraint(equalTo: calendarView.widthAnchor, multiplier: 6.0 / 7.0)
        ])

        clearButton.setTitle(NSLocalizedString("Clear", comment: ""), for: .normal)

        confirmButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
        confirmButton.isEnabled = self.date != nil

        let buttonStack = UIStackView(arrangedSubviews: [clearButton, confirmButton])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        view.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            buttonStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 44)
        ])

        monthButton.onTap { [unowned self] in
            guard let year = self.selectedYear else {
                warn("month mode was triggered without a year.")
                return
            }
            self.currentComponent = .month(year: year)
            self.monthButton.isEnabled = false
            self.yearButton.isEnabled = true
            self.triggerReload()
        }

        yearButton.onTap { [unowned self] in
            self.currentComponent = .year
            self.monthButton.isEnabled = true
            self.yearButton.isEnabled = false
            self.triggerReload()
        }

        clearButton.onTap { [unowned self] in
            self.currentComponent = .year
            self.date = nil
            self.selectedYear = nil
            self.selectedMonth = nil
            self.selectedDay = nil
            self.yearButton.setTitle(nil, for: .normal)
            self.yearButton.isEnabled = false
            self.monthButton.setTitle(nil, for: .normal)
            self.monthButton.isEnabled = false
            self.triggerReload()
            self.delegate?.calendarControllerClearedDate?(self)
        }

        confirmButton.onTap { [unowned self] in
            guard let date = self.date else {
                warn("Confirm was pressed without a date.")
                return
            }
            self.delegate?.calendarController?(self, didSelectDate: date)
        }

        applyStyle()
    }

    public override func viewDidLayoutSubviews() {
        if !hasLaidOutOnce {
            hasLaidOutOnce = true
            calendarLayout.setLayoutProperties(for: currentComponent)
            guard case .year = currentComponent, let index = dataSource.indexOfYear(Date().heart.year) else { return }
            calendarView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
        }
    }

    private func applyStyle() {
        yearButton.setTitleColor(style.enabledCalendarModeButtonColor ?? view.tintColor, for: .normal)
        yearButton.setTitleColor(style.disabledCalendarModeButtonColor, for: .disabled)
        yearButton.titleLabel?.font = style.calendarModeButtonFont

        monthButton.setTitleColor(style.enabledCalendarModeButtonColor ?? view.tintColor, for: .normal)
        monthButton.setTitleColor(style.disabledCalendarModeButtonColor, for: .disabled)
        monthButton.titleLabel?.font = style.calendarModeButtonFont

        clearButton.setTitleColor(style.enabledCalendarModeButtonColor ?? view.tintColor, for: .normal)
        clearButton.setTitleColor(style.disabledCalendarModeButtonColor, for: .disabled)
        clearButton.titleLabel?.font = style.calendarModeButtonFont

        confirmButton.setTitleColor(style.enabledCalendarModeButtonColor ?? view.tintColor, for: .normal)
        confirmButton.setTitleColor(style.disabledCalendarModeButtonColor, for: .disabled)
        confirmButton.titleLabel?.font = style.calendarModeButtonFont

        calendarHeader.arrangedSubviews.compactMap { $0 as? UILabel }.forEach {
            $0.font = style.calendarHeaderFont
            $0.textColor = style.headerTextColor
        }

        titleLabel.font = style.titleFont

        switch style.buttonConfiguration {
        case .none:
            clearButton.isHidden = true
            confirmButton.isHidden = true
        case .confirmationOnly:
            clearButton.isHidden = true
        default: break
        }
    }

    private func triggerReload() {
        // TODO : Determine how to set the content offset or scroll to an item as part of an animated
        // reload. The content offset/item to scroll to needs set up prior to animating the cells.
        UIView.animate(withDuration: 0.2, animations: {
            self.calendarView.alpha = 0
            self.calendarHeader.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0, animations: {
                self.calendarLayout.setLayoutProperties(for: self.currentComponent)
                self.calendarView.reloadData()
                guard case .year = self.currentComponent, self.selectedYear != nil else {
                    switch self.currentComponent {
                    case .year where self.selectedYear == nil:
                            if let indexPath = self.dataSource.indexOfYear(Date().heart.year).map({ IndexPath(item: $0, section: 0) }) {
                                self.calendarView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
                        }
                    default:
                        return
                    }
                    return
                }
                if let indexPath = self.dataSource.indexOfYear(Date().heart.year).map({ IndexPath(item: $0, section: 0) }) {
                    self.calendarView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
                }
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    if case .day = self.currentComponent { self.calendarHeader.alpha = 1 }
                    else { self.calendarHeader.alpha = 0 }
                    self.calendarView.alpha = 1
                })
            }
        }
    }

}

extension CalendarDateSelectionController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if case let .day(month, year) = currentComponent {
            let numberOfDays = dataSource.numberOfOptions(for: currentComponent)
            let offset = dataSource.offsetOfMonth(month, in: year)
            return Int(ceil(Float(offset + numberOfDays) / 7) * 7)
        }
        return dataSource.numberOfOptions(for: currentComponent)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectedColor = style.selectedBackgroundColor ?? view.tintColor!
        switch currentComponent {
        case .year:
            let cell: ComponentCell = collectionView.dequeue(at: indexPath)
            let year = dataSource.yearAtIndex(indexPath.item)
            let backgroundColor = year == selectedYear ? selectedColor : style.unselectedBackgroundColor
            let textColor = indexPath.row == selectedDay ? style.selectedTextColor : style.unselectedTextColor
            cell.configure(text: dataSource.stringFromYear(year), backgroundColor: backgroundColor, textColor: textColor)
            return cell
        case .month(let year):
            let cell: ComponentCell = collectionView.dequeue(at: indexPath)
            let month = type(of: dataSource).Common.months[indexPath.item]
            let backgroundColor = indexPath.month == selectedMonth ? selectedColor : style.unselectedBackgroundColor
            let textColor = indexPath.month == selectedDay ? style.selectedTextColor : style.unselectedTextColor
            let active = dataSource.monthIsAvailable(indexPath.month, inYear: year)
            cell.configure(text: month, backgroundColor: backgroundColor, textColor: textColor, active: active)
            return cell
        case .day(let month, let year):
            let numberOfDays = dataSource.numberOfOptions(for: currentComponent)
            let offset = dataSource.offsetOfMonth(month, in: year)
            guard indexPath.item >= offset && indexPath.item < offset + numberOfDays else {
                return collectionView.dequeue(at: indexPath) as EmptyCell
            }
            let cell: DayCell = collectionView.dequeue(at: indexPath)
            let day = indexPath.item - offset
            let backgroundColor = day + 1 == selectedDay ? selectedColor : .clear
            let textColor = day + 1 == selectedDay ? style.selectedTextColor : style.unselectedTextColor
            let active = dataSource.dayIsAvailable(day + 1, inMonth: month, year: year)
            cell.configure(with: "\(day + 1)", backgroundColor: backgroundColor, textColor: textColor, active: active)
            return cell
        }
    }

}

extension CalendarDateSelectionController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if case .day = currentComponent { return }
        guard let cell: ComponentCell = collectionView.cell(for: indexPath) else { return }
        cell.animateTouchDown()
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if case .day = currentComponent { return }
        guard let cell: ComponentCell = collectionView.cell(for: indexPath) else { return }
        cell.animateCancel()
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch currentComponent {
        case .year: return true
        case .month(year: let year): return dataSource.monthIsAvailable(indexPath.month, inYear: year)
        case .day(month: let month, year: let year):
            let numberOfDays = dataSource.numberOfOptions(for: currentComponent)
            let offset = dataSource.offsetOfMonth(month, in: year)
            guard indexPath.item >= offset && indexPath.item < offset + numberOfDays else { return false }
            return dataSource.dayIsAvailable(indexPath.item - offset + 1, inMonth: month, year: year)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = SelectionFeedbackGenerator()
        generator.prepare()
        switch currentComponent {
        case .year:
            let deselectedCell: ComponentCell? = selectedYear.flatMap(dataSource.indexOfYear)
                .map { IndexPath(item: $0, section: 0) }
                .flatMap(collectionView.cell(for:))
            selectedYear = dataSource.yearAtIndex(indexPath.item)
            yearButton.setTitle(dataSource.stringFromYear(selectedYear!), for: .normal)
            yearButton.isEnabled = true
            currentComponent = .month(year: selectedYear!)
            generator.selectionChanged()
            guard let selectedCell: ComponentCell = collectionView.cell(for: indexPath) else {
                // This and the other similar cases should never happen for obvious reasons, but in
                // the event that it does this will ensure that usability isn't totally hampered.
                triggerReload()
                return
            }
            transitionChipCells(selected: selectedCell, deselected: deselectedCell)
        case .month(year: let year):
            let deselectedCell: ComponentCell? = selectedMonth.map { IndexPath(item: $0 - 1, section: 0) }
                .flatMap(collectionView.cell(for:))
            selectedMonth = indexPath.month
            monthButton.setTitle(type(of: dataSource).Common.months[indexPath.item], for: .normal)
            monthButton.isEnabled = true
            currentComponent = .day(month: selectedMonth!, year: year)
            generator.selectionChanged()
            guard let selectedCell: ComponentCell = collectionView.cell(for: indexPath) else {
                triggerReload()
                return
            }
            transitionChipCells(selected: selectedCell, deselected: deselectedCell)
        case .day(month: let month, year: let year):
            let offset = dataSource.offsetOfMonth(month, in: year)
            let deselectedCell: DayCell? = selectedDay
                .map { IndexPath(item: $0 + offset - 1, section: 0) }
                .flatMap(collectionView.cell(for:))
            selectedDay = indexPath.item - offset + 1
            date = Date(day: selectedDay!, month: month, year: year)
            guard let selectedCell: DayCell = collectionView.cell(for: indexPath) else {
                if let date = self.date, self.style.buttonConfiguration == .none {
                    delegate?.calendarController?(self, didSelectDate: date)
                }
                return
            }
            transitionCalendarCells(selected: selectedCell, deselected: deselectedCell)
            if self.style.buttonConfiguration == .none {
                self.delegate?.calendarController?(self, didSelectDate: date!)
            }
            generator.selectionChanged()
        }
    }

    private func transitionChipCells(selected: ComponentCell, deselected: ComponentCell?) {
        let selectedBackgroundColor = style.selectedBackgroundColor ?? view.tintColor!
        let selectedTextColor = style.selectedTextColor ?? type(of: style).textColor(for: selectedBackgroundColor) ?? .black
        let unselectedBackgroundColor = style.unselectedBackgroundColor
        let unselectedTextColor = style.unselectedTextColor ?? type(of: style).textColor(for: unselectedBackgroundColor) ?? .black
        calendarView.isUserInteractionEnabled = false
        selected.animateSelection(backgroundColor: selectedBackgroundColor, textColor: selectedTextColor) {
            self.calendarView.isUserInteractionEnabled = true
            self.triggerReload()
        }
        guard selected != deselected else { return }
        deselected?.animateDeselection(backgroundColor: unselectedBackgroundColor, textColor: unselectedTextColor)
    }

    private func transitionCalendarCells(selected: DayCell, deselected: DayCell?) {
        let selectedBackgroundColor = style.selectedBackgroundColor ?? view.tintColor!
        let selectedTextColor = style.selectedTextColor ?? type(of: style).textColor(for: selectedBackgroundColor) ?? .black
        let unselectedTextColor = style.unselectedTextColor ?? .black
        guard selected != deselected else { return }
        selected.animateSelection(backgroundColor: selectedBackgroundColor, textColor: selectedTextColor) {
        }
        deselected?.animateDeselection(backgroundColor: .clear, textColor: unselectedTextColor)
    }

}

extension CalendarDateSelectionController: UIViewControllerTransitioningDelegate {

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: true)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: false)
    }

}

fileprivate func warn(_ message: String, _ function: String = #function, _ line: Int = #line) {
    print("\(CalendarDateSelectionController.self).\(function):\(line) WARN - \(message).")
}

fileprivate struct SelectionFeedbackGenerator {

    private let generator: Any?

    init() {
        if #available(iOS 10.0, *) {
            generator = UISelectionFeedbackGenerator()
        } else { generator = nil }
    }

    func prepare() {
        if #available(iOS 10.0, *) {
            (generator as? UISelectionFeedbackGenerator)?.prepare()
        }
    }

    func selectionChanged() {
        if #available(iOS 10.0, *) {
            (generator as? UISelectionFeedbackGenerator)?.selectionChanged()
        }
    }

}
