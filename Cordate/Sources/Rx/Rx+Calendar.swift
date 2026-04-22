import Foundation
@preconcurrency import RxCocoa
@preconcurrency import RxSwift

nonisolated(unsafe) fileprivate var delegateProxyKey = UInt8.max

@MainActor
public extension Reactive where Base: CalendarDateSelectionController {

    var date: ControlEvent<Date?> {
        let source = observe(Date?.self, #keyPath(CalendarDateSelectionController.date))
            .filter { $0 != nil }
            .map { $0! }
        return ControlEvent(events: source)
    }

    var selectedDate: ControlEvent<Date> {
        let proxy = MainActor.assumeIsolated { base.delegate as? CalendarDelegateProxy } ?? installProxy()
        let source = proxy.rx.methodInvoked(#selector(CalendarDateSelectionControllerDelegate.calendarController(_:didSelectDate:)))
            .map { args in args[1] as! Date }
        return ControlEvent(events: source)
    }

    var clearedDate: ControlEvent<Void> {
        let proxy = MainActor.assumeIsolated { base.delegate as? CalendarDelegateProxy } ?? installProxy()
        let source = proxy.rx.methodInvoked(#selector(CalendarDateSelectionControllerDelegate.calendarControllerClearedDate(_:)))
            .map { _ in () }
        return ControlEvent(events: source)
    }

    private func installProxy() -> CalendarDelegateProxy {
        return MainActor.assumeIsolated {
            let proxy = CalendarDelegateProxy(forwardedDelegate: base.delegate)
            base.delegate = proxy
            objc_setAssociatedObject(base, &delegateProxyKey, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return proxy
        }
    }

}

@MainActor
fileprivate class CalendarDelegateProxy: NSObject, CalendarDateSelectionControllerDelegate {

    weak var forwardedDelegate: CalendarDateSelectionControllerDelegate?

    init(forwardedDelegate: CalendarDateSelectionControllerDelegate?) {
        self.forwardedDelegate = forwardedDelegate
        super.init()
    }

    func calendarController(_ controller: CalendarDateSelectionController, didSelectDate date: Date) { }

    func calendarControllerClearedDate(_ controller: CalendarDateSelectionController) { }

}
