//
// Created by Mike on 7/31/21.
//

/// A value that describes the purpose of a button.
///
/// A button role provides a description of a button’s purpose. For example, the
/// ``destructive`` role indicates that a button performs a destructive action,
/// like delete user data:
///
/// ```swift
/// Button("Delete", role: .destructive) { delete() }
/// ```
public struct ButtonRole {
    /// A role that indicates a button that cancels an operation.
    ///
    /// Use this role for a button that cancels the current operation.
    public static let cancel = ButtonRole()

    /// A role that indicates a destructive button.
    ///
    /// Use this role for a button that deletes user data, or performs an
    /// irreversible operation. A destructive button signals by its appearance
    /// that the user should carefully consider whether to tap or click the
    /// button.
    public static let destructive = ButtonRole()
}
