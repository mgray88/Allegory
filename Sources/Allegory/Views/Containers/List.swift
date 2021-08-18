//
// Created by Mike on 8/9/21.
//

public struct List<SelectionValue, Content>: View
    where SelectionValue: Hashable, Content: View {

    /// Creates a list with the given content that supports selecting multiple
    /// rows.
    ///
    /// On iOS and tvOS, you must explicitly put the list into edit mode for
    /// the selection to apply.
    ///
    /// - Parameters:
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - content: The content of the list.
    public init(
        selection: Binding<Set<SelectionValue>>?,
        @ViewBuilder content: () -> Content
    ) {
        TODO()
    }

    /// Creates a list with the given content that supports selecting a single
    /// row.
    ///
    /// On iOS and tvOS, you must explicitly put the list into edit mode for
    /// the selection to apply.
    ///
    /// - Parameters:
    ///   - selection: A binding to a selected row.
    ///   - content: The content of the list.
    public init(
        selection: Binding<SelectionValue?>?,
        @ViewBuilder content: () -> Content
    ) {
        TODO()
    }
}

extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    public init<Data, RowContent>(
        _ data: Data,
        selection: Binding<Set<SelectionValue>>?,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) where Content == ForEach<Data, Data.Element.ID, RowContent>,
    Data: RandomAccessCollection,
    RowContent: View,
    Data.Element: Identifiable {

        TODO()
    }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    public init<Data, ID, RowContent>(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        selection: Binding<Set<SelectionValue>>?,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) where Content == ForEach<Data, ID, RowContent>,
    Data: RandomAccessCollection,
    ID: Hashable,
    RowContent: View {

        TODO()
    }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select multiple rows.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-8ef64``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    public init<RowContent>(
        _ data: Range<Int>,
        selection: Binding<Set<SelectionValue>>?,
        @ViewBuilder rowContent: @escaping (Int) -> RowContent
    ) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>,
    RowContent: View {

        TODO()
    }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    public init<Data, RowContent>(
        _ data: Data,
        selection: Binding<SelectionValue?>?,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) where Content == ForEach<Data, Data.Element.ID, RowContent>,
    Data: RandomAccessCollection,
    RowContent: View,
    Data.Element: Identifiable {

        TODO()
    }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    public init<Data, ID, RowContent>(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        selection: Binding<SelectionValue?>?,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) where Content == ForEach<Data, ID, RowContent>,
    Data: RandomAccessCollection,
    ID: Hashable,
    RowContent: View {

        TODO()
    }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select a single row.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-9r2hz``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    public init<RowContent>(
        _ data: Range<Int>,
        selection: Binding<SelectionValue?>?,
        @ViewBuilder rowContent: @escaping (Int) -> RowContent
    ) where Content == ForEach<Range<Int>, Int, RowContent>,
    RowContent: View {

        TODO()
    }
}
