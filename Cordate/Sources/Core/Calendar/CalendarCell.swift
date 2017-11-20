import Foundation
import UIKit

class DayCell: UICollectionViewCell {

    private let background = UIView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        background.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(background)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            background.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            background.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            background.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
        ])

        let topDivider = UIView()
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        topDivider.backgroundColor = .lightGray
        contentView.addSubview(topDivider)
        NSLayoutConstraint.activate([
            topDivider.topAnchor.constraint(equalTo: contentView.topAnchor),
            topDivider.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topDivider.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topDivider.bottomAnchor),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).ofPriority(.defaultHigh),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String, backgroundColor: UIColor, textColor: UIColor?, active: Bool) {
        label.text = text
        label.textColor = textColor ?? CalendarStyle.textColor(for: backgroundColor)
        background.backgroundColor = backgroundColor
        contentView.alpha = active ? 1 : 0.3
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        background.layer.cornerRadius = bounds.insetBy(dx: 8, dy: 8).width / 2
    }

    func animateSelection(backgroundColor: UIColor, textColor: UIColor, _ completion: @escaping () -> ()) {
        UIView.performWithoutAnimation {
            self.background.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
        UIView.animate(withDuration: 0.2) {
            self.background.transform = .identity
            self.background.backgroundColor = backgroundColor
        }
        UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.label.textColor = textColor
        }, completion: { _ in completion() })
    }

    func animateDeselection(backgroundColor: UIColor, textColor: UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.background.transform = .identity
            self.background.backgroundColor = backgroundColor
        }
        UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.label.textColor = textColor
        })
    }

}
