//
// Created by Mike on 8/24/21.
//

import Runtime
import UIKit

class Node {
    var children: [Node] = []
    var needsRebuild = true
    var view: SomeView!
    var previousView: SomeView?
    var environmentValues = EnvironmentValues()
    var stateProperties: [String: Any] = [:]

    func rebuildIfNeeded() {
        if needsRebuild {
            view.buildNodeTree(self)
        }
    }
}

extension SomeView {
    func buildNodeTree(_ node: Node) {
        if let primitive = self as? _PrimitiveView {
            node.view = self
            primitive.buildNodeTree(node)
            return
        }

        node.view = self

        let shouldRunBody = node.needsRebuild && !self.equalToPrevious(node)
        if !shouldRunBody {
            for child in node.children {
                child.rebuildIfNeeded()
            }
            return
        }

        self.observeObjects(node)

        var body = body
        if node.children.isEmpty {
            node.children = [Node()]
        }
        body.buildNodeTree(node.children[0])
        node.previousView = self
        node.needsRebuild = false
    }

    func restoreStateProperties(_ node: Node) {

    }

    func storeStateProperties(_ node: Node) {

    }
}

extension SomeView {
    func equalToPrevious(_ node: Node) -> Bool {
        guard let previous = node.previousView as? Self else { return false }
        do {
            let info = try typeInfo(of: Self.self)
            let properties = info.properties
            return try properties.allSatisfy { property in
                let selfVal = try property.get(from: self)
                let prevVal = try property.get(from: previous)
                return isEqual(selfVal, prevVal)
            }
        } catch {
            print(error)
        }
        return false
    }
}

extension SomeView {
    func observeObjects(_ node: Node) {
        guard let info = try? typeInfo(of: Self.self) else { return }
        do {
            var anyView: Any = self
            let dynamicProps = try info.dynamicProperties(
                &node.environmentValues,
                source: &anyView
            )
//            self = anyView as! Self
        } catch {
            assertionFailure()
        }
    }
}

extension EnvironmentValues {
    mutating func inject(into element: inout Any, _ type: Any.Type) throws {
        guard let info = try? typeInfo(of: type) else { return }

        if let modifier = element as? EnvironmentModifier {
            modifier.modifyEnvironment(&self)
        }

        // Inject @Environment values
        // swiftlint:disable force_cast
        // `DynamicProperty`s can have `@Environment` properties contained in them,
        // so we have to inject into them as well.
        for dynamicProp in info.properties.filter({ $0.type is DynamicProperty.Type }) {
            guard let propInfo = try? typeInfo(of: dynamicProp.type) else { return }
            var propWrapper = try dynamicProp.get(from: element) as! DynamicProperty
            for prop in propInfo.properties.filter({ $0.type is EnvironmentReader.Type }) {
                var wrapper = try prop.get(from: propWrapper) as! EnvironmentReader
                wrapper.setContent(from: self)
                try prop.set(value: wrapper, on: &propWrapper)
            }
            try dynamicProp.set(value: propWrapper, on: &element)
        }
        for prop in info.properties.filter({ $0.type is EnvironmentReader.Type }) {
            var wrapper = try prop.get(from: element) as! EnvironmentReader
            wrapper.setContent(from: self)
            try prop.set(value: wrapper, on: &element)
        }
        // swiftlint:enable force_cast
    }
}

extension TypeInfo {
    /// Extract all `DynamicProperty` from a type, recursively.
    /// This is necessary as a `DynamicProperty` can be nested.
    /// `EnvironmentValues` can also be injected at this point.
    func dynamicProperties(
        _ environment: inout EnvironmentValues,
        source: inout Any
    ) throws -> [PropertyInfo] {
        var dynamicProps = [PropertyInfo]()
        for prop in properties where prop.type is DynamicProperty.Type {
            dynamicProps.append(prop)
            guard let propInfo = try? typeInfo(of: prop.type) else { continue }

            try environment.inject(into: &source, prop.type)
            var extracted = try prop.get(from: source)
            dynamicProps.append(
                contentsOf: try propInfo.dynamicProperties(
                    &environment,
                    source: &extracted
                )
            )
            // swiftlint:disable:next force_cast
            var extractedDynamicProp = extracted as! DynamicProperty
            extractedDynamicProp.update()
            try? prop.set(value: extractedDynamicProp, on: &source)
        }
        return dynamicProps
    }
}

private func isEqual(_ lhs: Any, _ rhs: Any) -> Bool {
    func f<LHS>(lhs: LHS) -> Bool {
        if let typeInfo = Wrapped<LHS>.self as? AnyEquatable.Type {
            return typeInfo.isEqual(lhs: lhs, rhs: rhs)
        }
        return false
    }
    return _openExistential(lhs, do: f)
}

private protocol AnyEquatable {
    static func isEqual(lhs: Any, rhs: Any) -> Bool
}

private enum Wrapped<T> {}

extension Wrapped: AnyEquatable where T: Equatable {
    static func isEqual(lhs: Any, rhs: Any) -> Bool {
        guard let l = lhs as? T, let r = rhs as? T else {
            return false
        }
        return l == r
    }
}
