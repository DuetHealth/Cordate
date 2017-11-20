import Foundation
import UIKit

class ComponentCell: UICollectionViewCell {

    private let background = UIView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = 5
        contentView.addSubview(background)
        NSLayoutConstraint.activate([
            background.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            background.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            background.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        background.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: background.topAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: background.leftAnchor),
            label.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -8),
            label.rightAnchor.constraint(equalTo: background.rightAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, backgroundColor: UIColor, textColor: UIColor?, active: Bool = true) {
        label.text = text
        label.textColor = textColor ?? CalendarStyle.textColor(for: backgroundColor)
        background.backgroundColor = backgroundColor
        contentView.alpha = active ? 1 : 0.3
    }

    func animateTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    func animateCancel() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }

    func animateSelection(backgroundColor: UIColor, textColor: UIColor, _ completion: @escaping () -> ()) {
        UIView.performWithoutAnimation {
            self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .init(rawValue: 0), animations: {
            self.transform = .identity
        }, completion: { _ in completion() })
        UIView.animate(withDuration: 0.3) {
            self.background.backgroundColor = backgroundColor
        }
        UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.label.textColor = textColor
        })
    }

    func animateDeselection(backgroundColor: UIColor, textColor: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.background.backgroundColor = backgroundColor
        }
        UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.label.textColor = textColor
        })
    }

}
