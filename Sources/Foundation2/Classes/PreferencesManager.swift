/*
The MIT License (MIT)

Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel/PreferencesManagerSwift>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

public protocol PropertiesPreferences: RawStringRepresentable {
	/// Provies a defaultValue for each preference
	var defaultvalue: Any { get }
}
public protocol CustomPropertiesPreferences: RawStringRepresentable { }

#if swift(>=4.2)
@dynamicMemberLookup
#endif
/// A simple way to manage local values in your iOS apps.
///
/// Help and reference: [https://github.com/illescasDaniel/PreferencesManagerSwift]()
///
/// # Setup
///
/// * Create an enum which conforms to `String, PropertiesPreferences`.
/// * Optionally create another enum inside which conforms to `String, CustomPropertiesPreferences` for the custom classes.
///
/// * Example:
/// 	```
///		public enum Properties: String, PropertiesPreferences { ... }
///		```
///
/// ## Tip: create an extension for your Enum
///		extension PreferencesManager {
///			public subscript<T>(property: Properties) -> T? {
///				get { return self.userDefaults.value(fromKey: property.rawValue) }
///				set { self.userDefaults.set(newValue, forKey: property.	rawValue) }
///			}
///		}
/// # Usage
///
/// ## Get value:
/// ```
///	let username = PreferencesManager.standard[.username, default: "none"]
/// ```
///
/// ## Save value:
/// ```
///	PreferencesManager.standard[.username] = "daniel"
/// ```
public final class PreferencesManager {
	
	public static let standard = PreferencesManager()
	private let userDefaults: UserDefaults
	
	public init() { self.userDefaults = .standard }
	
	public init?(suiteName: String) {
		if let validUserDefaults = UserDefaults(suiteName: suiteName) {
			self.userDefaults = validUserDefaults
		}
		return nil
	}
	
	public func valueOrDefault<T, PropertiesEnumType: PropertiesPreferences>(for property: PropertiesEnumType) -> T! {
		return self[property] ?? (property.defaultvalue as! T)
	}
	
	public subscript<T, PropertiesEnumType: PropertiesPreferences>(property: PropertiesEnumType, default defaultvalue: T) -> T {
		return self[property] ?? defaultvalue
	}
	public subscript<T: Codable, CustomPropertieEnumType: CustomPropertiesPreferences>(property: CustomPropertieEnumType, default defaultvalue: T) -> T {
		return self[property] ?? defaultvalue
	}
	
	#if swift(>=4.2)
	public subscript<T,PropertiesEnumType: PropertiesPreferences>(property: PropertiesEnumType) -> T? {
	get { return self[dynamicMember: property.rawValue] }
	set { self[dynamicMember: property.rawValue] = newValue }
	}
	public subscript<T>(dynamicMember propertyKey: String) -> T? {
	get { return self.userDefaults.value(fromKey: propertyKey) }
	set { self.userDefaults.set(newValue, forKey: propertyKey) }
	}
	#else
	public subscript<T,PropertiesEnumType: PropertiesPreferences>(property: PropertiesEnumType) -> T? {
		get { return self.userDefaults.value(fromKey: property.rawValue) }
		set { self.userDefaults.set(newValue, forKey: property.rawValue) }
	}
	public subscript<T>(property: String) -> T? {
		get { return self.userDefaults.value(fromKey: property) }
		set { self.userDefaults.set(newValue, forKey: property) }
	}
	#endif
	
	public subscript<T: Codable, CustomPropertieEnumType: CustomPropertiesPreferences>(property: CustomPropertieEnumType) -> T? {
		get { return self.userDefaults.decodableValue(fromKey: property.rawValue) }
		set { self.userDefaults.set(newValue.inJSON, forKey: property.rawValue) }
	}
	
	public func setMultiple<PropertiesEnumType: PropertiesPreferences>(_ values: [PropertiesEnumType: Any]) {
		values.forEach { self[$0.key] = $0.value }
	}
	
	public func setMultiple<T: Codable, CustomPropertieEnumType: CustomPropertiesPreferences>(_ values: [CustomPropertieEnumType: T]) { // Might not be very useful because it would only allow one type (T)
		values.forEach { self[$0.key] = $0.value }
	}
	
	public func remove<PropertiesEnumType: RawStringRepresentable>(property: PropertiesEnumType) {
		self.userDefaults.removeObject(forKey: property.rawValue)
	}
}

public extension UserDefaults {
	
	public func value<T>(fromKey propertyKey: String) -> T? {
		guard self.object(forKey: propertyKey) != nil else { return nil }
		switch T.self {
		case is Int.Type: return self.integer(forKey: propertyKey) as? T
		case is String.Type: return self.string(forKey: propertyKey) as? T
		case is Double.Type: return self.double(forKey: propertyKey) as? T
		case is Float.Type: return self.float(forKey: propertyKey) as? T
		case is Bool.Type: return self.bool(forKey: propertyKey) as? T
		case is URL.Type: return self.url(forKey: propertyKey) as? T
		case is Data.Type: return self.data(forKey: propertyKey) as? T
		case is [String].Type: return self.stringArray(forKey: propertyKey) as? T
		case is [Any].Type: return self.array(forKey: propertyKey) as? T
		case is [String: Any?].Type: return self.dictionary(forKey: propertyKey) as? T
		default: return self.object(forKey: propertyKey) as? T
		}
	}
	
	public func decodableValue<T: Decodable>(fromKey propertyKey: String) -> T? {
		guard self.object(forKey: propertyKey) != nil else { return nil }
		return self.string(forKey: propertyKey)?.decoded()
	}
}

public extension Encodable {
	public var inJSON: String {
		if let data = try? JSONEncoder().encode(self), let jsonQuiz = String(data: data, encoding: .utf8) {
			return jsonQuiz
		}
		return ""
	}
}

public extension String {
	public func decoded<T: Decodable>() -> T? {
		if let data = self.data(using: .utf8), let decodedValue = try? JSONDecoder().decode(T.self, from: data) {
			return decodedValue
		}
		return nil
	}
}
