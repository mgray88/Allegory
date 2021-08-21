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
