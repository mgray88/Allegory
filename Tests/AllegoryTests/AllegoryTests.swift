import XCTest
@testable import Allegory

class Model: RxObservableObject {
    @RxPublished var counter: Int = 0
}

let nestedModel = Model()

extension View {
    func debug(_ f: () -> ()) -> Self {
        f()
        return self
    }
}

var nestedBodyCount = 0
var contentViewBodyCount = 0

struct ContentView: View {
    var model = Model()
    var body: SomeView {
        Button("\(model.counter)") {
            model.counter += 1
        }
    }
}

final class AllegoryTests: XCTestCase {
    override func setUp() {
        nestedBodyCount = 0
        contentViewBodyCount = 0
        nestedModel.counter = 0
    }

    func testUpdate() throws {
        let v = ContentView()
        let node = v.resolve(context: Context(), cachedNode: nil) as! ViewNode
        let button = node.view.body as! Button<Text>
        XCTAssertEqual(button.label, Text("0"))
        button.action()
        node.needsRebuild = true
        node.rebuildIfNeeded()
        XCTAssertEqual(button.label, Text("1"))
    }

    func testUnchangedNested() {
        struct Nested: View {
            var isLarge: Bool = false
            var body: SomeView {
                nestedBodyCount += 1
                return Button("Nested Button", action: {})
            }
        }

        struct ContentView: View {
            @RxObservedObject var model = Model()

            @ViewBuilder
            public var body: SomeView {
                Button("\(model.counter)") {
                    model.counter += 1
                }
                Nested(isLarge: model.counter > 10)
                    .debug {
                        contentViewBodyCount += 1
                    }
            }
        }

        var v = ContentView()
        let node = Node()
        v.buildNodeTree(node)
        XCTAssertEqual(contentViewBodyCount, 1)
        XCTAssertEqual(nestedBodyCount, 1)
        var button: Button<Text> {
            node.children[0].children[0].view as! Button<Text>
        }
        button.action()
        node.needsRebuild = true
        node.rebuildIfNeeded()
        XCTAssertEqual(contentViewBodyCount, 2)
        XCTAssertEqual(nestedBodyCount, 1)
    }

    func testExample() throws {
        struct Nested: View {
            @RxObservedObject var model = nestedModel
            var body: SomeView {
                Button("Nested Button", action: {})
            }
        }

        struct ContentView: View {
            @RxObservedObject var model = Model()

            @ViewBuilder
            var body: SomeView {
                Button("\(model.counter)") {
                    model.counter += 1
                }
                Nested()
                    .debug {
                        contentViewBodyCount += 1
                    }
            }
        }
    }
}
