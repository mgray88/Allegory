//
// Created by Mike on 7/29/21.
//

/// Protocol representing "some" ``View`` in lieu of `some View`
public protocol SomeView {
    var body: SomeView { get }
}
