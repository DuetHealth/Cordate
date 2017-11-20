import Foundation

struct OnceToken {

    struct Token {
        fileprivate let ptr: UnsafeMutableRawPointer
        fileprivate init(_ ptr: UnsafeMutableRawPointer) {
            self.ptr = ptr
        }
    }

    fileprivate struct Payload {
        static let incomplete = UInt8(0)
        static let complete = UInt8(1)
    }

    fileprivate static let mutex = NSObject()

    fileprivate(set) var payload = [Payload.incomplete]

    var token: Token {
        return Token.init(payload.withUnsafeBytes { ptr in
            return UnsafeMutableRawPointer(mutating: ptr.baseAddress!)
        })
    }

    init() { }

}

extension DispatchQueue {

    func once(_ token: OnceToken.Token, _ function: () -> ()) {
        objc_sync_enter(OnceToken.mutex)
        defer { objc_sync_exit(OnceToken.mutex) }
        if token.ptr.load(as: UInt8.self) == OnceToken.Payload.complete { return }
        function()
        token.ptr.storeBytes(of: OnceToken.Payload.complete, as: UInt8.self)
    }

}
