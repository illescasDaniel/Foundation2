# Foundation2

[![Swift version](https://img.shields.io/badge/Swift-4-orange.svg)](https://kotlinlang.org/)[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/illescasDaniel/Foundation2/blob/master/LICENSE)[![Version](https://img.shields.io/badge/version-1.4.0-green.svg)](https://github.com/illescasDaniel/Foundation2/releases)

A great collection of extensions, protocols and classes that improves Swift and extend the Foundation module 😉.

## Content

- **Operators**:

  - **Power operator**: `**`

    ```swift
    print(5 ** 2) // 25
    ```

  - **String similarity operator**: `=~`

    ```swift
    // Will return true if the two strings are 85% similar or above.
    print("Daniel Illescas" =~ "Daniel ilescas")
    ```

  - **Apply operator**: `=>` 

    ```swift
    let daniel = Human() => { its in
      its.name = "Daniel"
      its.age = 10
    }
    ```

  - **Operators to trim strings**: `<>`, `<|>`

    ```swift
    let name = "John "
    print(name<>) // "John"
    var name = " Daniel "
    name<|> // name = "Daniel"
    ```

  - **Default value operators**: `..`, `..|`. Works with `String`, `Numeric`, `Dictionary`, `Initiable`...

    ```swift
    let paths: [String]? = nil
    print(paths..) // []
    let value: Float? = nil
    print(value..) // value = 0
    ```

- **Protocols**:

  - **AutoProtocols**: `AutoEquatable`, `AutoCustomDebugStringConvertible`,`AutoCustomStringConvertible`, `AutoComparable`. 
  
  - **Initiable**: `protocol Initiable { init() }`. Making a type conform to this protocol allows it to create an instance in generic functions where `<T: Initiable>`.

  - **Arithmetic protocols**: that allows you to perform some extra operations with generic types (useful when using `Numeric` types).  `ModulusArithmetic`. 


- **Extensions**:

  - **UIAlertController**: `addAction(title:, style:, handler:) `.

  - **UIColor**: extensions for DisplayP3, RBG, Hex values, return RGB components...

  - **UIImage**: `contentsOf(url:)`,  `manageContentsOf(_ url:, completionHandler:, errorHandler:)`, `isLandscape`, `isPortrait`, `resizedImage(to targetSize:)`, `averageColor`, `resizedWith(width:)`, `resizedWith(height:)`.

  - **UIColor**: `lighter(by percentage:)`, `darker(by percentage:)`, `isLight`, `isDark`, `inGrayScale`.

  - **Collection**: `subscript (safe index: Index)`, `sum`.

  - **String**: 
    - Default implementation for `CustomStringConvertible.description` with reflection.
    - `subscript(index: Int)`, `var deletingPathExtension: String `, `var localized: String`.
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

  - **CaseIterable (Swift 4.2 or >)**: `all` (allCases mapped to its RawValue).

  - **CIContext**: easy properties to use a metal context or a OpenGL context. 

  - **Mirror**: `deepChildren(of originalValue: )`

  - **Extensions for Swift 4.1 or lower**: `shuffle()`, `shuffled`, `Array.hashValue`, `CaseIterableEnum`, `Collection.randomElement` .
    

- **Classes**:

  * [**CachedImages**](https://github.com/illescasDaniel/CachedImages): an easy class to manage online images in Swift. 

  * [**File**](https://github.com/illescasDaniel/Files-swift): manage files easier with this struct.

  * [**PreferencesManager**](https://github.com/illescasDaniel/PreferencesManagerSwift): a simple way to manage local values in your iOS apps. 

  * [**HapticFeedback**](https://github.com/illescasDaniel/HapticFeedbackPlayer): create simple haptic feedback patters easily. 

  * [**ToastAlert**](https://github.com/illescasDaniel/ToastAlert): a basic toast-like alert, similar to what to find in Android. 

  * **Reachability**: easily know if the device is connnected to a network or not. 

  * [**CSVWriter**](https://github.com/illescasDaniel/CSVWriter): a CSV writer made in Swift. 

  * **IAPViewController**: a viewController which lets you easily control your purchases. 

  * **TrueRandom**: very useful type which handles millions of random numbers. 

  * **SwiftMutex**: `PthreadMutex`, `Semaphore`, `NSLock.sync`. 



## Instalation

- **Swift package manager**:

  Add `Foundation2` in your `Package.swift` dependencies.

  Like this (take a look at the **Sample** folder):

  ```swift
  import PackageDescription

  let package = Package(
      name: "Sample",
      dependencies: [
          .package(url: "https://github.com/illescasDaniel/Foundation2.git", from: "1.4"),
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

- Normal project:

  * Save your currect project as a workspace (on the same directory of your project).
  * Close your project and open the workspace.
  * Drag all the files of this repo (except for the Sample folder) to the same directory as your project workspace.
  * Open your workspace and drag the `Foundation2.xcodeproj` project at the same level as yours in Xcode.
  * Go to your `Linked Frameworks and Libraries` and add `Foundation2.framework
