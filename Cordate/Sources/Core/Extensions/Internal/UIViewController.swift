import Foundation
import UIKit

extension UIViewController {

    var topAnchor: NSLayoutYAxisAnchor {
        return view.safeAreaLayoutGuide.topAnchor
    }

    var leftAnchor: NSLayoutXAxisAnchor {
        return view.safeAreaLayoutGuide.leftAnchor
    }

    var bottomAnchor: NSLayoutYAxisAnchor {
        return view.safeAreaLayoutGuide.bottomAnchor
    }

    var rightAnchor: NSLayoutXAxisAnchor {
        return view.safeAreaLayoutGuide.rightAnchor
    }

}
