import Foundation
@preconcurrency import RxCocoa
@preconcurrency import RxSwift

@MainActor
public extension Reactive where Base: ManualDateField {

    var date: ControlProperty<Date?> {
        let source = base.rx.text.map { _ in self.base.date }
        let sink = Binder<Date?>(base) { field, date in
            field.setDate(date)
        }
        return ControlProperty(values: source, valueSink: sink)
    }

}
