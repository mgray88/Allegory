//
// Created by Mike on 7/31/21.
//

internal struct GeometryCache {

    internal var pass: LayoutPass = .init()
    internal var geometry: [CGSize: ContentGeometry] = [:]

    public init() {}

    internal func geometry(for pass: LayoutPass, size: CGSize) -> ContentGeometry? {
        guard self.pass == pass else { return nil }
        return geometry[size]
    }

    internal mutating func update(pass: LayoutPass, size: CGSize, geometry: ContentGeometry) {
        if self.pass != pass {
            self.pass = pass
            self.geometry.removeAll(keepingCapacity: true)
        }
        self.geometry[size] = geometry
    }
}
