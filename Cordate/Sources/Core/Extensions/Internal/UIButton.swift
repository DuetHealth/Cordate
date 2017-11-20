import Foundation
import UIKit

fileprivate var key = UInt8.max

extension UIButton {

    class Closure: NSObject {
        let closure: () -> ()

        init(_ closure: @escaping () -> ()) {
            self.closure = closure
        }
    }

    @objc private func invoke() {
        let closure = objc_getAssociatedObject(self, &key) as! Closure
        closure.closure()
    }

    func onTap(_ closure: @escaping () -> ()) {
        objc_setAssociatedObject(self, &key, Closure(closure), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(invoke), for: .touchUpInside)
    }

}
