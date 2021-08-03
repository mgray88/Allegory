//
// Created by Mike on 7/29/21.
//

extension Never: View {
    public var body: Never {
        fatalError()
    }
}

extension Never: Shape {
    public static var role: ShapeRole {
        fatalError()
    }

    public func path(in rect: CGRect) -> Path {
        fatalError()
    }
}
