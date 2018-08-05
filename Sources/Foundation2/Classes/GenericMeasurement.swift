//
//  GenericMeasurement.swift
//  Foundation2
//
//  Created by Daniel Illescas Romero on 05/08/2018.
//

import class Foundation.NSUnit.Dimension
import class Foundation.NSUnit.UnitConverterLinear
import struct Foundation.Measurement

@available(iOS 10.0, OSX 10.12, *)
open class UnitGeneric: Dimension {
	
	open class var yotta: UnitGeneric {
		return UnitGeneric(symbol: "Y", converter: UnitConverterLinear(coefficient: 10 ** 24, constant: 0))
	}
	open class var zetta: UnitGeneric {
		return UnitGeneric(symbol: "Z", converter: UnitConverterLinear(coefficient: 10 ** 21, constant: 0))
	}
	open class var exa: UnitGeneric {
		return UnitGeneric(symbol: "E", converter: UnitConverterLinear(coefficient: 10 ** 18, constant: 0))
	}
	open class var peta: UnitGeneric {
		return UnitGeneric(symbol: "P", converter: UnitConverterLinear(coefficient: 10 ** 15, constant: 0))
	}
	open class var tera: UnitGeneric {
		return UnitGeneric(symbol: "T", converter: UnitConverterLinear(coefficient: 10 ** 12, constant: 0))
	}
	open class var giga: UnitGeneric {
		return UnitGeneric(symbol: "G", converter: UnitConverterLinear(coefficient: 10 ** 9, constant: 0))
	}
	open class var mega: UnitGeneric {
		return UnitGeneric(symbol: "M", converter: UnitConverterLinear(coefficient: 10 ** 6, constant: 0))
	}
	open class var kilo: UnitGeneric {
		return UnitGeneric(symbol: "k", converter: UnitConverterLinear(coefficient: 10 ** 3, constant: 0))
	}
	open class var hecto: UnitGeneric {
		return UnitGeneric(symbol: "h", converter: UnitConverterLinear(coefficient: 10 ** 2, constant: 0))
	}
	open class var deka: UnitGeneric {
		return UnitGeneric(symbol: "da", converter: UnitConverterLinear(coefficient: 10 ** 1, constant: 0))
	}
	open class var deci: UnitGeneric {
		return UnitGeneric(symbol: "d", converter: UnitConverterLinear(coefficient: 10 ** -1, constant: 0))
	}
	open class var centi: UnitGeneric {
		return UnitGeneric(symbol: "c", converter: UnitConverterLinear(coefficient: 10 ** -2, constant: 0))
	}
	open class var milli: UnitGeneric {
		return UnitGeneric(symbol: "m", converter: UnitConverterLinear(coefficient: 10 ** -3, constant: 0))
	}
	open class var micro: UnitGeneric {
		return UnitGeneric(symbol: "µ", converter: UnitConverterLinear(coefficient: 10 ** -6, constant: 0))
	}
	open class var nano: UnitGeneric {
		return UnitGeneric(symbol: "n", converter: UnitConverterLinear(coefficient: 10 ** -9, constant: 0))
	}
	open class var pico: UnitGeneric {
		return UnitGeneric(symbol: "p", converter: UnitConverterLinear(coefficient: 10 ** -12, constant: 0))
	}
	open class var femto: UnitGeneric {
		return UnitGeneric(symbol: "f", converter: UnitConverterLinear(coefficient: 10 ** -15, constant: 0))
	}
	open class var atto: UnitGeneric {
		return UnitGeneric(symbol: "a", converter: UnitConverterLinear(coefficient: 10 ** -18, constant: 0))
	}
	open class var zepto: UnitGeneric {
		return UnitGeneric(symbol: "z", converter: UnitConverterLinear(coefficient: 10 ** -21, constant: 0))
	}
	open class var yocto: UnitGeneric {
		return UnitGeneric(symbol: "y", converter: UnitConverterLinear(coefficient: 10 ** -24, constant: 0))
	}
	open class var unit: UnitGeneric {
		return baseUnit()
	}
	
	override open class func baseUnit() -> UnitGeneric {
		return UnitGeneric(symbol: "", converter: UnitConverterLinear(coefficient: 1, constant: 0))
	}
	
	open class func convert(value: Double, toBaseUnitFrom genericUnit: UnitGeneric) -> Double {
		return GenericMeasurement(value: value, unit: genericUnit).converted(to: .unit).value
	}
}

@available(iOS 10.0, OSX 10.12, *)
public typealias GenericMeasurement = Measurement<UnitGeneric>

// TODO: LOCALE FORMATTER too!

@available(iOS 10.0, OSX 10.12, *)
public extension Measurement where UnitType == UnitGeneric {
	public func toString() -> String {
		return "\(self)"
	}
}

@available(iOS 10.0, OSX 10.12, *)
public extension Double {
	
	public func `in`(_ unit: UnitGeneric) -> Double {
		return GenericMeasurement(value: self, unit: .unit).converted(to: unit).value
	}
	
	public func inMeasurement(unit: UnitGeneric) -> GenericMeasurement {
		return GenericMeasurement(value: self, unit: .unit).converted(to: unit)
	}
	
	private func converted(from unit: UnitGeneric) -> Double {
		return UnitGeneric.convert(value: self, toBaseUnitFrom: unit)
	}
	
	/// Value to Yotta (10 ^ 24)
	public var Y: Double { return converted(from: .yotta) }
	
	/// Value to Zetta (10 ^ 21)
	public var Z: Double { return converted(from: .zetta) }
	
	/// Value to Exa (10 ^ 18)
	public var E: Double { return converted(from: .exa) }
	
	/// Value to Peta (10 ^ 15)
	public var P: Double { return converted(from: .peta) }
	
	/// Value to Tera (10 ^ 12)
	public var T: Double { return converted(from: .tera) }
	
	/// Value to Giga (10 ^ 9)
	public var G: Double { return converted(from: .giga) }
	
	/// Value to Mega (10 ^ 6)
	public var M: Double { return converted(from: .mega) }
	
	/// Value to kilo (10 ^ 3)
	public var k: Double { return converted(from: .kilo) }
	
	/// Value to hecto (10 ^ 2)
	public var h: Double { return converted(from: .hecto) }
	
	/// Value to deka (10 ^ 1)
	public var da: Double { return converted(from: .deka) }
	
	/// Value to deci (10 ^ -1)
	public var d: Double { return converted(from: .deci) }
	
	/// Value to centi (10 ^ -2)
	public var c: Double { return converted(from: .centi) }
	
	/// Value to mili (10 ^ -3)
	public var m: Double { return converted(from: .milli) }
	
	/// Value to micro (10 ^ -6)
	public var µ: Double { return converted(from: .micro) }
	
	/// Value to nano (10 ^ -9)
	public var n: Double { return converted(from: .nano) }
	
	/// Value to pico (10 ^ -12)
	public var p: Double { return converted(from: .pico) }
	
	/// Value to fempto (10 ^ -15)
	public var f: Double { return converted(from: .femto) }
	
	/// Value to atto (10 ^ -18)
	public var a: Double { return converted(from: .atto) }
	
	/// Value to zepto (10 ^ -21)
	public var z: Double { return converted(from: .zepto) }
	
	/// Value to yocto (10 ^ -24)
	public var y: Double { return converted(from: .yocto) }
	
	/// Example: 10_000 -> 10 k
	public var formatted: GenericMeasurement {
		switch abs(self) {
		case (0.0..<1.z): return self.inMeasurement(unit: .yocto)
		case (1.z..<1.a): return self.inMeasurement(unit: .zepto)
		case (1.a..<1.f): return self.inMeasurement(unit: .atto)
		case (1.f..<1.p): return self.inMeasurement(unit: .femto)
		case (1.p..<1.n): return self.inMeasurement(unit: .pico)
		case (1.n..<1.µ): return self.inMeasurement(unit: .nano)
		case (1.µ..<1.m): return self.inMeasurement(unit: .micro)
		case (1.m..<1): return self.inMeasurement(unit: .milli)
		case (1..<1.k): return self.inMeasurement(unit: .unit)
		case (1.k..<1.M): return self.inMeasurement(unit: .kilo)
		case (1.M..<1.G): return self.inMeasurement(unit: .mega)
		case (1.G..<1.T): return self.inMeasurement(unit: .giga)
		case (1.T..<1.P): return self.inMeasurement(unit: .tera)
		case (1.P..<1.E): return self.inMeasurement(unit: .peta)
		case (1.E..<1.Z): return self.inMeasurement(unit: .exa)
		case (1.Z..<1.Y): return self.inMeasurement(unit: .zetta)
		case (1.Y..<Double.infinity): return self.inMeasurement(unit: .yotta)
		default: return self.inMeasurement(unit: .unit)
		}
	}
}
