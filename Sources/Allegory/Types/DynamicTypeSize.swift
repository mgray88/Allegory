//
// Created by Mike on 9/5/21.
//

public enum DynamicTypeSize: Hashable, Comparable, CaseIterable {
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    case xxxLarge
    case accessibility1
    case accessibility2
    case accessibility3
    case accessibility4
    case accessibility5

    public var isAccessibilitySize: Bool {
        self >= .accessibility1
    }
}

extension EnvironmentValues {
    private struct DynamicTypeSizeKey: EnvironmentKey {
        static let defaultValue: DynamicTypeSize = .medium
    }

    public var dynamicTypeSize: DynamicTypeSize {
        get { self[DynamicTypeSizeKey.self] }
        set { self[DynamicTypeSizeKey.self] = newValue }
    }
}

extension View {
    public func dynamicTypeSize(
        _ size: DynamicTypeSize
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<DynamicTypeSize>> {
        modifier(.init(
            keyPath: \.dynamicTypeSize,
            value: size
        ))
    }

    public func dynamicTypeSize<T>(
        _ range: T
    ) -> ModifiedContent<Self, _EnvironmentKeyTransformModifier<DynamicTypeSize>>
        where T: RangeExpression, T.Bound == DynamicTypeSize {
        modifier(.init(
            keyPath: \.dynamicTypeSize
        ) { (dynamicTypeSize: inout DynamicTypeSize) in
            TODO()
        })
    }
}
