<div align="center">

# FirebaseFirestoreSwiftManual — Lightweight Swift Property Wrappers for Cloud Firestore

[![Swift](https://img.shields.io/badge/Swift-5.9+-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://developer.apple.com/swift/)
[![iOS](https://img.shields.io/badge/iOS-14.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-11.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/macos/)
[![SwiftPM](https://img.shields.io/badge/Package_Manager-SwiftPM-orange?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![Firebase](https://img.shields.io/badge/Database-Cloud_Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/docs/firestore)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg?style=for-the-badge)](LICENSE)

<p align="center">
  A self-contained, lightweight alternative to <code>FirebaseFirestoreSwift</code> providing seamless <b>Swift Codable</b> mapping for <b>@DocumentID</b> and <b>@ServerTimestamp</b> without Swift Package Manager dependency conflicts.
</p>

</div>

---

## Table of Contents
- [Overview](#overview)
- [Why This Package Exists](#why-this-package-exists)
- [Core Property Wrappers](#core-property-wrappers)
- [Code Examples](#code-examples)
- [Installation via SwiftPM](#installation-via-swiftpm)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Author & License](#author--license)

---

## Overview

**FirebaseFirestoreSwiftManual** provides a drop-in replacement for the property wrapper extensions traditionally bundled inside Google's `FirebaseFirestoreSwift` framework. It enables iOS and macOS developers to decode and encode Cloud Firestore document IDs and server-generated timestamps into native Swift models using standard `Codable` protocols.

---

## Why This Package Exists

When integrating the official Firebase iOS SDK via Swift Package Manager (SPM), developers often encounter dependency resolution issues, build target duplications, or missing dynamic symbols for `FirebaseFirestoreSwift`. 

This package solves those issues by:
- **Zero Binary Bloat:** Extracts only the essential `@DocumentID` and `@ServerTimestamp` property wrappers.
- **SPM-First Architecture:** Compatible with modern Swift Package Manager workflows on iOS 14+ and macOS 11+.
- **Decoupled Maintenance:** Enables apps to compile cleanly even during breaking SDK updates.

---

## Core Property Wrappers

### 1. `@DocumentID`
Automatically maps the Firestore document's unique identifier to a Swift model property during decoding, and prevents the document ID from being written into the document payload during serialization:

```swift
struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
}
```

### 2. `@ServerTimestamp`
Handles server-side timestamp generation (`FieldValue.serverTimestamp()`) on insertion and decodes Firestore Timestamp objects directly into native Swift `Date` objects:

```swift
struct TransactionRecord: Identifiable, Codable {
    @DocumentID var id: String?
    var amount: Double
    @ServerTimestamp var timestamp: Date?
}
```

---

## Code Examples

### Full Model Definition & Firestore Query
```swift
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwiftManual

// Define your Codable domain model
struct BarberService: Identifiable, Codable {
    @DocumentID var id: String?
    var serviceName: String
    var price: Int
    @ServerTimestamp var createdAt: Date?
}

// Decoding documents from Firestore
func fetchServices(completion: @escaping ([BarberService]) -> Void) {
    let db = Firestore.firestore()
    db.collection("services").getDocuments { snapshot, error in
        guard let documents = snapshot?.documents, error == nil else { return }
        
        let services = documents.compactMap { doc -> BarberService? in
            try? doc.data(as: BarberService.self)
        }
        completion(services)
    }
}
```

---

## Installation via SwiftPM

Add the package dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/a360n/FirebaseFirestoreSwiftManual.git", from: "1.0.0")
]
```

Or in Xcode:
1. Navigate to **File -> Add Package Dependencies...**
2. Enter repository URL: `https://github.com/a360n/FirebaseFirestoreSwiftManual.git`
3. Select version rule and add to your target.

---

## Tech Stack

- **Language:** Swift 5.9+
- **Platforms:** iOS 14.0+, macOS 11.0+
- **Dependencies:** `FirebaseFirestore` (Google Firebase iOS SDK)
- **Design Pattern:** Swift Property Wrappers, Custom Decodable / Encodable Initializers

---

## Project Structure

```
FirebaseFirestoreSwiftManual/
├── Package.swift                    # SwiftPM Manifest
├── Sources/
│   └── FirebaseFirestoreSwiftManual/
│       ├── DocumentID.swift         # @DocumentID Implementation & Decoding Keys
│       └── ServerTimestamp.swift    # @ServerTimestamp Protocol & Wrappers
├── LICENSE                          # Apache 2.0 License
└── README.md                        # Technical Documentation
```

---

## Author

**Ali Nasser (Ali Al-Khazali)**
- Portfolio: [www.ali-nasser.dev](https://www.ali-nasser.dev)
- GitHub: [@a360n](https://github.com/a360n)
- LinkedIn: [Ali Nasser](https://www.linkedin.com/in/ali-nasser-dev/)

---

## License

This project is licensed under the Apache License 2.0 — see the [LICENSE](LICENSE) file for details.
