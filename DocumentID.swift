//
//  DocumentID.swift
//
//  Adapted manually to provide Firestore Swift Codable support for @DocumentID
//  when FirebaseFirestoreSwift module is unavailable in Swift Package Manager.
//
//  Source inspired from Firebase iOS SDK (https://github.com/firebase/firebase-ios-sdk)
//
//  Created by Ali Al-Khazali (SecureChat Project)
//

import Foundation
import FirebaseFirestore
import FirebaseSharedSwift

// MARK: - Manual Firestore Coding Errors
enum ManualFirestoreCodingError: Error {
    case decodingIsNotSupported(String)
    case encodingIsNotSupported(String)
}

// MARK: - CodingUserInfoKey extension
extension CodingUserInfoKey {
    static let documentRefUserInfoKey = CodingUserInfoKey(rawValue: "DocumentRefUserInfoKey")!
}

// MARK: - DocumentIDWrappable Protocol
public protocol DocumentIDWrappable {
    static func wrap(_ documentReference: DocumentReference) throws -> Self
}

// MARK: - String and DocumentReference conform to DocumentIDWrappable
extension String: DocumentIDWrappable {
    public static func wrap(_ documentReference: DocumentReference) throws -> Self {
        return documentReference.documentID
    }
}

extension DocumentReference: DocumentIDWrappable {
    public static func wrap(_ documentReference: DocumentReference) throws -> Self {
        return documentReference as! Self
    }
}

// MARK: - DocumentIDProtocol
protocol DocumentIDProtocol {
    init(from documentReference: DocumentReference?) throws
}

// MARK: - DocumentID Property Wrapper
@propertyWrapper
public struct DocumentID<Value: DocumentIDWrappable & Codable>: StructureCodingUncodedUnkeyed {
    private var value: Value? = nil

    public init(wrappedValue value: Value?) {
        if let value {
            logIgnoredValueWarning(value: value)
        }
        self.value = value
    }

    public var wrappedValue: Value? {
        get { value }
        set { value = newValue }
    }

    private func logIgnoredValueWarning(value: Value) {
        FirebaseLogger.log(
            level: .warning,
            service: "[FirebaseFirestore]",
            code: "I-FST000002",
            message: """
            Attempting to initialize or set a @DocumentID property with a non-nil value: "\(value)".
            The document ID is managed by Firestore and will be automatically set when reading from Firestore.
            """
        )
    }
}

// MARK: - DocumentID Protocol Conformance
extension DocumentID: DocumentIDProtocol {
    init(from documentReference: DocumentReference?) throws {
        if let documentReference {
            value = try Value.wrap(documentReference)
        } else {
            value = nil
        }
    }
}

// MARK: - Codable Conformance
extension DocumentID: Codable {
    public init(from decoder: Decoder) throws {
        guard let reference = decoder
            .userInfo[CodingUserInfoKey.documentRefUserInfoKey] as? DocumentReference else {
            throw ManualFirestoreCodingError.decodingIsNotSupported(
                """
                Could not find DocumentReference for user info key: \(CodingUserInfoKey.documentRefUserInfoKey).
                DocumentID values can only be decoded with Firestore.Decoder.
                """
            )
        }
        try self.init(from: reference)
    }

    public func encode(to encoder: Encoder) throws {
        throw ManualFirestoreCodingError.encodingIsNotSupported(
            "DocumentID values can only be encoded with Firestore.Encoder."
        )
    }
}

// MARK: - Equatable & Hashable
extension DocumentID: Equatable where Value: Equatable {}
extension DocumentID: Hashable where Value: Hashable {}
