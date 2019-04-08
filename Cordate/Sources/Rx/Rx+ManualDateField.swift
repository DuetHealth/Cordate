import Foundation
import RxCocoa
import RxSwift

public extension Reactive where Base: ManualDateField {

    /// Returns a Reactive control property which emits changes to the field's date and accepts new
    /// dates.
    var date: ControlProperty<Date?> {
        let source = base.rx.text.map { _ in self.base.date }
        let sink = Binder<Date?>(base) { field, date in
            field.setDate(date)
        }
        return ControlProperty(values: source, valueSink: sink)
    }

}
