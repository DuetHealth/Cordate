import Foundation
import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.view(forKey: presenting ? .to : .from),
            let controller = transitionContext.viewController(forKey: presenting ? .to : .from) else { return }
        let containerView = transitionContext.containerView
        if presenting {
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(view)

            let preferredSize = controller.preferredContentSize

            if preferredSize.width > 0 {
                view.widthAnchor.constraint(equalToConstant: preferredSize.width).isActive = true
            }

            if preferredSize.height > 0 {
                view.heightAnchor.constraint(equalToConstant: preferredSize.height).isActive = true
            }

            NSLayoutConstraint.activate([
                view.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
                view.leftAnchor.constraint(greaterThanOrEqualTo: containerView.leftAnchor, constant: 16),
                view.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
                view.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -16),
                view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])

            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
                view.alpha = 1
                view.transform = .identity
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn, animations: {
                view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }

}
