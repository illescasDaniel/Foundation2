# Foundation2

[![Swift version](https://img.shields.io/badge/Swift-4-orange.svg)](https://kotlinlang.org/)[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/illescasDaniel/Foundation2/blob/master/LICENSE)[![Version](https://img.shields.io/badge/version-1.0.4-green.svg)](https://github.com/illescasDaniel/Foundation2/releases)

A great collection of extensions, protocols and classes that improves Swift and extend the Foundation module 😉.

## Contents

- **Extensions**:

  - **UIAlertController**: `addAction(title:, style:, handler:) `.

  - **UIColor**: extensions for DisplayP3, RBG, Hex values, return rub components...

  - **UIImage**: `contentsOf(url:)`,  `manageContentsOf(_ url:, completionHandler:, errorHandler:)` .

  - **AVAudioPlayer**: `convenience init?(file:, type:, volume:)`, `setVolumeLevel(to:, duration:)` 

  - **Collection**: `subscript (safe index: Index)`.

  - **String**: 
    - Default implementation for `CustomStringConvertible.description` with reflection.
    - `subscript(index: Int) `, `var deletingPathExtension: String `, `var localized: String`.

  - **Numeric protocols** and extensions, `Initiable`  (`init{}`) protocol, etc.

  - **BinaryInteger**: `isEven`, `isOdd`, `isPrime`.

  - Extensions for Swift 4.1 or lower (`shuffle()`, `shuffled`, `Array.hashValue`)

    

- **Classes**:

  * [**CachedImages**](https://github.com/illescasDaniel/CachedImages): an easy class to manage online images in Swift. 

  * [**File**](https://github.com/illescasDaniel/Files-swift): manage files easier with this struct.

  * [**PreferencesManager**](https://github.com/illescasDaniel/PreferencesManagerSwift): a simple way to manage local values in your iOS apps. 

  * [**HapticFeedback**](https://github.com/illescasDaniel/HapticFeedbackPlayer): create simple haptic feedback patters easily. 

  * [**ToastAlert**](https://github.com/illescasDaniel/ToastAlert): a basic toast-like alert, similar to what to find in Android. 

  * [**CSVWriter**](https://github.com/illescasDaniel/CSVWriter): a CSV writer made in Swift. 

  * **TrueRandom**: very useful type which handles millions of random numbers. 

  * **SwiftMutex**: `PthreadMutex`, `Semaphore`, `NSLock.sync`. 

    

- **Operators**:

  - **Power operator**: `**` (5 ** 2 = 25)

  - **Apply operator**: `=>` 

  - ```swift
    let daniel = Human() => { its in
      its.name = "Daniel"
      its.age = 10
    }
    ```

## Instalation

Add `Foundation2`in your `Package.swift`dependencies.

Like this:

```swift
import PackageDescription

let package = Package(
    name: "Foundation2App",
    dependencies: [
        .package(url: "../Foundation2", from: "1.0.4"),
    ],
    targets: [
        .target(
            name: "Foundation2App",
            dependencies: [
                "Foundation2",
            ]),
    ]
)
```