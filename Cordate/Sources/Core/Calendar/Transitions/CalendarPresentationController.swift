import Foundation
import UIKit

fileprivate let defaultStyle: UIBlurEffectStyle = {
    if #available(iOS 10.0, *) { return .regular }
    return .light
}()

/// The `CalendarPresentationController` class is a subclass of `UIPresentationController` which
/// provides default behaviors and styling for the `CalendarDateSelectionController`.
public class CalendarPresentationController: UIPresentationController {

    private let blurEffectView = UIVisualEffectView()
    private let tapGestureRecognizer = UITapGestureRecognizer()

    /// The blur effect used by the overlay.
    /// On iOS 10 and above, this defaults to `.regular`; on iOS 9, the default is `.light`.
    public var blurEffect = UIBlurEffect(style: defaultStyle)

    /// Controls whether touches on the blur overlay trigger a dismissal.
    ///
    /// The default value of this is `true`.
    public var overlayTouchesShouldDismiss: Bool = true {
        didSet {
            tapGestureRecognizer.isEnabled = overlayTouchesShouldDismiss
        }
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.addTarget(self, action: #selector(triggerDismissal))
    }

    override public var shouldRemovePresentersView: Bool {
        return false
    }

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView, let coordinator = presentingViewController.transitionCoordinator else { return }
        containerView.addSubview(blurEffectView)
        blurEffectView.frame = containerView.bounds
        presentedView?.layer.cornerRadius = 10
        presentedView?.layer.shadowOffset = CGSize(width: 0, height: 4)
        presentedView?.layer.shadowColor = UIColor.black.cgColor
        presentedView?.layer.shadowOpacity = 0.3
        presentedView?.layer.shadowRadius = 20
        blurEffectView.contentView.addSubview(presentedViewController.view)
        coordinator.animate(alongsideTransition: { context in
            self.blurEffectView.effect = self.blurEffect
        })
    }

    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed { blurEffectView.removeFromSuperview()}
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }

    override public func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        blurEffectView.removeGestureRecognizer(tapGestureRecognizer)
        coordinator.animate(alongsideTransition: { context in
            self.blurEffectView.effect = nil
        }, completion: nil)
    }

    override public func dismissalTransitionDidEnd(_ completed: Bool) {
        blurEffectView.removeFromSuperview()
    }

    @objc private func triggerDismissal() {
        presentingViewController.dismiss(animated: true)
    }

}

