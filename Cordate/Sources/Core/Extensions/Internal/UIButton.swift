import Foundation
import UIKit

nonisolated(unsafe) fileprivate var key = UInt8.max

extension UIButton {

    class Closure: NSObject {
        let closure: @MainActor () -> ()

        init(_ closure: @escaping @MainActor () -> ()) {
            self.closure = closure
        }
    }

    @objc private func invoke() {
        let closure = objc_getAssociatedObject(self, &key) as! Closure
        closure.closure()
    }

    func onTap(_ closure: @escaping @MainActor () -> ()) {
        objc_setAssociatedObject(self, &key, Closure(closure), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(invoke), for: .touchUpInside)
    }

}
