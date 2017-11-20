import Foundation

extension DateComponents {

    init(_ builder: (inout DateComponents) -> ()) {
        self.init()
        builder(&self)
    }

}
