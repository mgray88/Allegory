//
// Created by Mike on 7/29/21.
//

/// A custom parameter attribute that constructs views from closures.
@resultBuilder
public struct ViewBuilder {
    /// Builds an empty view from a block containing no statements.
    public static func buildBlock() -> EmptyView {
        EmptyView()
    }

    /// Passes a single view written as a child view through unmodified.
    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: View {
        content
    }
}

extension ViewBuilder {
    /// Provides support for “if” statements in multi-statement closures,
    /// producing an optional view that is visible only when the condition
    /// evaluates to `true`.
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: View {
        content
    }

    /// Provides support for “if” statements in multi-statement closures,
    /// producing conditional content for the “then” branch.
    public static func buildEither<TrueContent: View, FalseContent: View>(
        first: TrueContent
    ) -> ConditionalContent<TrueContent, FalseContent> {
        ConditionalContent(first)
    }

    /// Provides support for “if-else” statements in multi-statement closures,
    /// producing conditional content for the “else” branch.
    public static func buildEither<TrueContent: View, FalseContent: View>(
        second: FalseContent
    ) -> ConditionalContent<TrueContent, FalseContent> {
        ConditionalContent(second)
    }

    /// Provides support for “if” statements with ``#available()`` clauses in
    /// multi-statement closures, producing conditional content for the “then”
    /// branch, i.e. the conditionally-available branch.
    static func buildLimitedAvailability<Content>(
        _ content: Content
    ) -> AnyView where Content : View {
        AnyView(content)
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleView<(C0, C1)> where C0: View, C1: View {
        TupleView((c0, c1))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleView<(C0, C1, C2)> where C0: View, C1: View, C2: View {
        TupleView((c0, c1, c2))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleView<(C0, C1, C2, C3)> where C0: View, C1: View, C2: View, C3: View {
        TupleView((c0, c1, c2, c3))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleView<(C0, C1, C2, C3, C4)> where C0: View, C1: View, C2: View, C3: View, C4: View {
        TupleView((c0, c1, c2, c3, c4))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleView<(C0, C1, C2, C3, C4, C5)> where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View {
        TupleView((c0, c1, c2, c3, c4, c5))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleView<(C0, C1, C2, C3, C4, C5, C6)> where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View {
        TupleView((c0, c1, c2, c3, c4, c5, c6))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)> where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View {
        TupleView((c0, c1, c2, c3, c4, c5, c6, c7))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View {
        TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }
}

extension ViewBuilder {
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View {
        TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }
}
