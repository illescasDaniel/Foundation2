//
//  NumberFormatter.swift
//  Foundation2
//
//  Created by Daniel Illescas Romero on 14/07/2018.
//

import Foundation

public extension NumberFormatter {
	public convenience init(decimalSeparator: String, numberStyle: NumberFormatter.Style) {
		self.init()
		self.decimalSeparator = decimalSeparator
		self.numberStyle = numberStyle
	}
	public convenience init(decimalSeparator: String) {
		self.init()
		self.decimalSeparator = decimalSeparator
	}
}
