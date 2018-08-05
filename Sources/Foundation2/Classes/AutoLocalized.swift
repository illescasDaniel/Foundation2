//
//  AutoLocalized.swift
//  Foundation2
//
//  Created by Daniel Illescas Romero on 26/07/2018.
//

import class Foundation.NSDictionary
import struct Foundation.URL
import struct Foundation.CharacterSet

/// Generates an entire class to easily access the localized strings in your code.
///
/// # Setup
///		In your Localizable.strings format your keys like this:
///		"**Settings.Options.Music**" = "Background Music";
///		...
///
///	# Usage
///	After saving the generated class file you can use use it like this
///
///		print(Localized.Settings_Options_Music) // ~ "Background Music"
class AutoLocalized {
	
	private let filePath: String
	
	init(localizableFilePath: String = "../en.lproj/Localizable.strings") {
		self.filePath = localizableFilePath
	}
	
	var output: String {
		
		var tempOutput = """
		/* Automatically generated with "AutoLocalized.swift" */
		class Localized {
		
		"""
		
		if let stringsDictionary = NSDictionary(contentsOfFile: self.filePath) as? [String: String] {
			for (key, _) in stringsDictionary where key.starts(with: "**") {
				let simpleName = key.trimmingCharacters(in: CharacterSet(charactersIn: "*"))
				tempOutput += """
				static let \(simpleName.replacingOccurrences(of: ".", with: "_")) = "\(key)".localized\n
				"""
			}
		}
		
		
		tempOutput += """
		}
		"""
		return tempOutput
	}
	
	@discardableResult
	func save(to path: String) -> Bool {
		let url = URL(fileURLWithPath: path) // for example: "/Users/Daniel/Documents/Xcode/Questions/Questions/Localized.swift"
		if ((try? self.output.write(to: url, atomically: true, encoding: .utf8)) == nil) {
			print("Error writing Localized.swift")
			return false
		}
		return true
	}
}
