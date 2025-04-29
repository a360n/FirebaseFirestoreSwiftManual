//
//  ServerTimestamp.swift
//
//  Adapted manually to provide Firestore Swift Codable support for @ServerTimestamp
//  when FirebaseFirestoreSwift module is unavailable in Swift Package Manager.
//
//  Source inspired from Firebase iOS SDK (https://github.com/firebase/firebase-ios-sdk)
//
//  Created by Ali Al-Khazali (SecureChat Project)
//

import Foundation
import FirebaseCore

// MARK: - ServerTimestampWrappable Protocol

/// A protocol to make types compatible with Firestore `@ServerTimestamp` property wrapper.
public protocol ServerTimestampWrappable {
    /// Creates a new instance by converting from a Firestore `Timestamp`.
    static func wrap(_ timestamp: Timestamp) throws -> Self

    /// Converts this value into a Firestore `Timestamp`.
    static func unwrap(_ value: Self) throws -> Timestamp
}

// MARK: - Date and Timestamp conform to ServerTimestampWrappable

extension Date: ServerTimestampWrappable {
    public static func wrap(_ timestamp: Timestamp) throws -> Self {
        return timestamp.dateValue()
    }

    public static func unwrap(_ value: Self) throws -> Timestamp {
        return Timestamp(date: value)
    }
}

extension Timestamp: ServerTimestampWrappable {
    public static func wrap(_ timestamp: Timestamp) throws -> Self {
        return timestamp as! Self
    }

    public static func unwrap(_ value: Timestamp) throws -> Timestamp {
        return value
    }
}

// MARK: - ServerTimestamp Property Wrapper

/// A property wrapper that marks an `Optional<Timestamp>` or `Optional<Date>`
/// field to be automatically populated with the server timestamp when writing.
///
/// Example usage:
/// ```swift
/// struct Post: Codable {
///   @ServerTimestamp var createdAt: Timestamp?
/// }
/// ```
///
/// Writing an object with `createdAt = nil` will instruct Firestore to fill it with the current server timestamp.
@propertyWrapper
public struct ServerTimestamp<Value>: Codable where Value: ServerTimestampWrappable & Codable {
    private var value: Value?

    public init(wrappedValue value: Value?) {
        self.value = value
    }

    public var wrappedValue: Value? {
        get { value }
        set { value = newValue }
    }

    // MARK: - Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = nil
        } else {
            value = try Value.wrap(container.decode(Timestamp.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value {
            try container.encode(Value.unwrap(value))
        } else {
            try container.encode(FieldValue.serverTimestamp())
        }
    }
}

// MARK: - Conformances

extension ServerTimestamp: Equatable where Value: Equatable {}
extension ServerTimestamp: Hashable where Value: Hashable {}
extension ServerTimestamp: Sendable where Value: Sendable {}
