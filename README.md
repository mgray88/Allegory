# Allegory

### SwiftUI but UIKit (plus a little RxSwift)

Allegory is a library built to resemble SwiftUI as much as possible built on top of UIKit for use on iOS versions starting from iOS 10.

See [Progress](docs/Progress.md)

## Example

Allegory is designed to be almost identical to SwiftUI, except that the body of your views returns `SomeView` instead of `some View`.

```swift
struct Counter: View {
    @State var count: Int
    let limit: Int

    var body: SomeView {
        if count < limit {
            VStack {
                Button("Increment") { count += 1 }
                Text("\(count)")
            }
            // Not yet implemented
            // .onAppear { print("Counter.VStack onAppear") }
            // .onDisappear { print("Counter.VStack onDisappear") }
        } else {
            VStack { Text("Limit exceeded") }
        }
    }
}

@main
struct CounterApp: App {
    var body: SomeScene {
        WindowGroup("Counter Demo") {
            Counter(count: 5, limit: 15)
        }
    }
}
```

## Installation

#### With [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod 'Allegory', '~> 0.0.2'
```

#### With [Swift Package Manager](https://swift.org/package-manager/)

In Xcode 12.3+ go to `File -> Swift Packages -> Add Package Dependency` and enter there URL of this repo
```
https://github.com/mgray88/Allegory
```

## WIP

Allegory is a highly dynamic work in progress. Much of it is not ready for use.

## Author

#### Mike Gray
- Twitter: [@MikeMgray88](https://twitter.com/MikeMgray88)

## Acknowledgements
Many, many thanks to these other open source projects and resources that have inspired and provided insight on the inner workings of SwiftUI  
- [Mockingbird](https://github.com/DeclarativeHub/Mockingbird) and [MockingbirdUIKit](https://github.com/DeclarativeHub/MockingbirdUIKit)
- [RxSwiftWidgets](https://github.com/hmlongco/RxSwiftWidgets)
- [UIKitPlus](https://github.com/MihaelIsaev/UIKitPlus)
- [Tokamak](https://github.com/TokamakUI/Tokamak)
- [SwiftUI Layout Explained](https://talk.objc.io/collections/swiftui-layout-explained) @ [objc.io](https://www.objc.io/)
- [SwiftUI State Explained](https://talk.objc.io/collections/swiftui-state-explained) @ [objc.io](https://www.objc.io/)

SwiftUI is a trademark owned by Apple Inc. Software maintained as a part of the Allegory project is not affiliated with Apple Inc.

## License

Allegory is available under the MIT license. See [LICENSE](LICENSE) for more info.
