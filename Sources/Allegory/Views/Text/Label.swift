//
// Created by Mike on 9/26/21.
//

public struct Label<Title, Icon>: View where Title: View, Icon: View {

    internal let title: Title
    internal let icon: Icon

    public init(
        @ViewBuilder title: () -> Title,
        @ViewBuilder icon: () -> Icon
    ) {
        self.title = title()
        self.icon = icon()
    }

    public var body: SomeView {
        HStack {
            title
            icon
        }
    }
}

extension Label where Title == Text, Icon == Image {
//    public init(_ titleKey: LocalizedStringKey, image name: String)
//    public init(_ titleKey: LocalizedStringKey, systemImage name: String)

    public init<S>(
        _ title: S,
        image name: String
    ) where S: StringProtocol {
        self.init { Text(title) } icon: { Image(name) }
    }

    @available(iOS 13.0, *)
    public init<S>(
        _ title: S,
        systemImage name: String
    ) where S: StringProtocol {
        self.init { Text(title) } icon: { Image(systemName: name) }
    }
}
