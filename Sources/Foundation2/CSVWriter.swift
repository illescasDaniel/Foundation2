/*
The MIT License (MIT)

Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel/CSVWriter>

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

public extension NumberFormatter {
	public convenience init(decimalSeparator: String, numberStyle: NumberFormatter.Style) {
		self.init()
		self.currencyDecimalSeparator = decimalSeparator
		self.numberStyle = numberStyle
	}
}

/// A CSV writer made in Swift.
///
/// # Usage
///	```
/// CSVWriter(separator: ";", columns: historyKeys, useDefaultNumberFormatter: true)
///		.addNumbersRow(historyValues, withTitle: "Fitness")
///		.save(to: URL(fileURLWithPath: "\(directoryRoot)/4/Output/SimulatedAnnealing-3.csv"))
/// ```
public final class CSVWriter {
	
	private(set) var outputCSV: String = ""
	public let numberFormatter: NumberFormatter?
	
	public let separator: String
	public let columns: [String]
	public let outputFile: URL?
	
	private init(separator: String, columns: [String], useDefaultNumberFormatter: Bool = false, numberFormatter: NumberFormatter?, outputFile: URL? = nil) {
		
		self.separator = separator
		self.columns = columns
		
		if let validNumberFormatter = numberFormatter {
			self.numberFormatter = validNumberFormatter
		} else {
			self.numberFormatter = useDefaultNumberFormatter ? NumberFormatter(decimalSeparator: ",", numberStyle: .decimal) : nil
		}
		
		self.outputFile = outputFile
		
		if useDefaultNumberFormatter || numberFormatter != nil {
			self.addRow(columns)
		} else {
			self.addRawRow(columns)
		}
	}
	
	public convenience init(separator: String, columns: String..., useDefaultNumberFormatter: Bool = false, outputFile: URL? = nil) {
		self.init(separator: separator, columns: columns,useDefaultNumberFormatter: useDefaultNumberFormatter, numberFormatter: nil, outputFile: outputFile)
	}
	
	public convenience init(separator: String, columns: [String], useDefaultNumberFormatter: Bool = false, outputFile: URL? = nil) {
		self.init(separator: separator, columns: columns,useDefaultNumberFormatter: useDefaultNumberFormatter, numberFormatter: nil, outputFile: outputFile)
	}
	
	public convenience init(separator: String, columns: String..., numberFormatter: NumberFormatter, outputFile: URL? = nil) {
		self.init(separator: separator, columns: columns, useDefaultNumberFormatter: false, numberFormatter: numberFormatter, outputFile: outputFile)
	}
	
	@discardableResult public  func addRow(withValues columnValues: Any..., withTitle title: String = "") -> CSVWriter {
		return self.addRow(columnValues, withTitle: title)
	}
	
	@discardableResult public  func addRow(_ columnValues: [Any], withTitle title: String = "") -> CSVWriter {
		
		let stringColumnValues: [String] = columnValues.map { value in
			if let numberFormatter = numberFormatter, let number = value as? NSNumber, let validString = numberFormatter.string(from: number) {
				return validString
			}
			return String(describing: value)
		}
		
		return !title.isEmpty ? self.addRow([title] + stringColumnValues) : self.addRow(stringColumnValues)
	}
	
	public static func +=(lhs: CSVWriter, rhs: [Any]) {
		lhs.addRow(rhs)
	}
	
	@discardableResult public func addRow(_ columnValues: [String]) -> CSVWriter {
		
		if columnValues.count == self.columns.count {
			
			let newRow = columnValues.joined(separator: self.separator) + "\n"
			self.outputCSV += newRow
			
			if let validOutputFile = self.outputFile {
				File.append(newRow, to: validOutputFile)
			}
		}
		return self
	}
	
	public func save(to path: URL, restartWriterAfterSaving: Bool = false) {
		
		File.save(self.outputCSV, to: path)
		
		if restartWriterAfterSaving {
			self.restartWriter()
		}
	}
	
	public func restartWriter() {
		self.outputCSV = ""
		self.addRow(self.columns)
	}
}

public extension CSVWriter {
	
	public convenience init<Type: CustomStringConvertible>(separator: String, columns: [Type], useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map{ $0.description }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	public convenience init<Type: CustomStringConvertible>(separator: String, columns: Type..., useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map{ $0.description }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	public convenience init(separator: String, columns: [Any], useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map { String(describing: $0) }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	public convenience init(separator: String, columns: Any..., useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map { String(describing: $0) }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	@discardableResult public func addRawRow(withValues columnValues: Any...) -> CSVWriter {
		self.addRow(withValues: columnValues)
		return self
	}
	
	@discardableResult func addRawRow(_ columnValues: [Any]) -> CSVWriter {
		self.addRow(columnValues.map { String(describing: $0) })
		return self
	}
}
