import Foundation
import UIKit

extension UIViewController {

    var topAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return topLayoutGuide.bottomAnchor
        }
    }

    var leftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.leftAnchor
        } else {
            return view.leftAnchor
        }
    }

    var bottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return view.bottomAnchor
        }
    }

    var rightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.rightAnchor
        } else {
            return view.rightAnchor
        }
    }

}
