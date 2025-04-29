# FirebaseFirestoreSwiftManual

A lightweight manual alternative to `FirebaseFirestoreSwift` that enables Swift Codable support for Firestore `@DocumentID` and `@ServerTimestamp`.

This package is designed to be used when `FirebaseFirestoreSwift` is not available through Swift Package Manager (SPM) or you need a minimal manual replacement.

---

## Why This Exists
Google's official Firebase iOS SDK includes `FirebaseFirestoreSwift`, but it is sometimes:
- Unavailable through SPM (Swift Package Manager).
- Delayed in updates compared to CocoaPods integration.
- Bundled with heavier dependencies you might not need.

This project extracts and adapts the necessary functionality to enable:
- `@DocumentID`
- `@ServerTimestamp`

without requiring the full `FirebaseFirestoreSwift` module.

---

## What's Included

| File | Purpose |
|:---|:---|
| `DocumentID.swift` | Property wrapper for Firestore Document ID mapping |
| `ServerTimestamp.swift` | Property wrapper for automatic server timestamp mapping |

---

## Installation

Since this is a manual integration, simply:

1. Download or clone this repository.
2. Copy the `Sources/` folder into your Xcode project.
3. Make sure your project already imports:
   - `FirebaseFirestore`
   - `FirebaseCore`

---

## Usage

### Using `@DocumentID`
```swift
struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String
    var username: String
}
```
When you retrieve a document from Firestore, the `id` will be automatically filled with the document's ID.

### Using `@ServerTimestamp`
```swift
struct Message: Codable {
    @ServerTimestamp var createdAt: Timestamp?
    var text: String
}
```
When you write a `Message` with `createdAt = nil`, Firestore will automatically fill it with the server's current time.

---

## Requirements

- iOS 14+
- Swift 5.7+
- Firebase iOS SDK 10.0.0+

---

## Important Notes
- This package manually replicates parts of the official `FirebaseFirestoreSwift`.
- You should update manually if Google makes major changes to Firestore Codable behavior.
- Not officially maintained by Google or Firebase team.

---

## License
This project is licensed under the Apache License 2.0.

You are free to use, modify, and distribute this project under the terms of the Apache 2.0 License.


---

## Contributions

Feel free to fork and enhance!

- Add support for more property wrappers if needed.
- Improve Codable compliance.
- Extend documentation.

---

Created  by Ali Nasser for the SecureChat Project.
