# Foundation2

[![Swift version](https://img.shields.io/badge/Swift-4-orange.svg)](https://kotlinlang.org/)[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/illescasDaniel/Foundation2/blob/master/LICENSE)[![Version](https://img.shields.io/badge/version-1.2.0-green.svg)](https://github.com/illescasDaniel/Foundation2/releases)

A great collection of extensions, protocols and classes that improves Swift and extend the Foundation module 😉.

## Contents

- **Extensions**:

  - **UIAlertController**: `addAction(title:, style:, handler:) `.

  - **UIColor**: extensions for DisplayP3, RBG, Hex values, return RGB components...

  - **UIImage**: `contentsOf(url:)`,  `manageContentsOf(_ url:, completionHandler:, errorHandler:)` , `isLandscape`, `isPortrait`, `resizedImage(to targetSize:)`, `averageColor`.

  - **UIColor**: `lighter(by percentage:)`, `darker(by percentage:)`, `isLight`, `isDark`, `inGrayScale`.

  - **Collection**: `subscript (safe index: Index)`.

  - **String**: 
    - Default implementation for `CustomStringConvertible.description` with reflection.
    - `subscript(index: Int) `, `var deletingPathExtension: String `, `var localized: String`.
    - `clear()`, `isNumeric`, `levenshteinDistanceScoreTo(string:, ...)`

  - **UIView**: `mapEverySubview(block:)` 

  - **AVAudioPlayer**: `convenience init?(file:, type:, volume:)`, `setVolumeLevel(to:, duration:)` 

  - **AVFoundation.AVMetadataObject**: `name`, `allBarcodes`, `twoDBarcodes`, `is1DBarcode`. 

  - **UIApplication**: `openURL(from url:, completionHandler:)`, `openSettings()`, `versionNumber`, `buildNumber`, `versionAndBuildNumber`. 

  - **UIDevice**: `modelName`, `hasNotchOrExtraInsets`.

  - **Numeric protocols** and extensions, `Initiable`  (`init{}`) protocol, etc.

  - **BinaryInteger**: `isEven`, `isOdd`, `isPrime`.

  - **FloatingPoint**: `π`, `τ`, `tau`.

  - **RawRepresentable**: `rawLocalized`.

  - **CIContext**: easy properties to use a metal context or a OpenGL context. 

  - **Extensions for Swift 4.1 or lower**: `shuffle()`, `shuffled`, `Array.hashValue`, `CaseIterableEnum`, `Collection.randomElement` .

    

- **Classes**:

  * [**CachedImages**](https://github.com/illescasDaniel/CachedImages): an easy class to manage online images in Swift. 

  * [**File**](https://github.com/illescasDaniel/Files-swift): manage files easier with this struct.

  * [**PreferencesManager**](https://github.com/illescasDaniel/PreferencesManagerSwift): a simple way to manage local values in your iOS apps. 

  * [**HapticFeedback**](https://github.com/illescasDaniel/HapticFeedbackPlayer): create simple haptic feedback patters easily. 

  * [**ToastAlert**](https://github.com/illescasDaniel/ToastAlert): a basic toast-like alert, similar to what to find in Android. 

  * **Reachability**: easily know if the device is connnected to a network or not. 

  * [**CSVWriter**](https://github.com/illescasDaniel/CSVWriter): a CSV writer made in Swift. 

  * **IAP**: a class to inherit from which lets you easily control your purchases. 

  * **TrueRandom**: very useful type which handles millions of random numbers. 

  * **SwiftMutex**: `PthreadMutex`, `Semaphore`, `NSLock.sync`. 

    

- **Operators**:

  - **Power operator**: `**` (5 ** 2 = 25)

  - **StringSimilarity operator**: `=~`

    ```swift
    // Will return true if the two strings are 85% similar or above.
    print("Daniel Illescas" =~ "Daniel ilescas")
    ```

  - **Apply operator**: `=>` 

  - ```swift
    let daniel = Human() => { its in
      its.name = "Daniel"
      its.age = 10
    }
    ```

## Instalation

Add `Foundation2`in your `Package.swift`dependencies.

Like this (take a look at the **Sample** folder):

```swift
import PackageDescription

let package = Package(
    name: "Sample",
    dependencies: [
        .package(url: "https://github.com/illescasDaniel/Foundation2.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "Sample",
            dependencies: [
                "Foundation2"
            ]),
    ]
)
```