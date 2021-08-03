//
//  Identifiable.swift
//  Identifiable
//
//  Created by Mike on 8/2/21.
//

public protocol Identifiable {
    associatedtype ID: Hashable
    var id: Self.ID { get }
}

extension Identifiable where Self: AnyObject {
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}

extension Identifiable where Self: Hashable {
    public var id: Self {
        self
    }
}
