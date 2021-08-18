//
// Created by Mike on 7/30/21.
//

public func TODO(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("TODO: \(message())", file: file, line: line)
}

public func notSupported(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Not yet supported. \(message())", file: file, line: line)
}

public func abstractMethod(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Abstract method must be implemented. \(message())", file: file, line: line)
}

/// Calls `fatalError` with an explanation that a given `type` is a primitive `View`
public func neverBody(_ type: @autoclosure () -> String) -> Never {
    fatalError("\(type()) is a primitive `View`, you're not supposed to access its `body`.")
}
