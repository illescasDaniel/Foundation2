//
//  EmptyRepresentable.swift
//  Foundation2
//
//  Created by Daniel Illescas Romero on 05/08/2018.
//

/// Inspired on: https://forums.swift.org/t/presence-value-isempty-nil-value/14869
public protocol EmptyRepresentable {
	var isEmpty: Bool { get }
	var isNotEmpty: Bool { get }
	var presence: Self? { get }
}

public extension EmptyRepresentable {
	
	/// Returns Self if the value is not empty, nil otherwise
	var presence: Self? {
		return self.isEmpty ? nil : self
	}
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
}

extension Optional where Wrapped: EmptyRepresentable {
	
	/// Returns Self if the value is not empty, nil otherwise
	public var presence: Wrapped? {
		if let value = self {
			return value.isEmpty ? nil : value
		}
		return nil
	}
}

extension Array: EmptyRepresentable { }
extension Set: EmptyRepresentable { }
extension ContiguousArray: EmptyRepresentable { }
extension Dictionary: EmptyRepresentable { }
extension String: EmptyRepresentable { }

public extension String {
	var nonBlankPresence: String? {
		return self.isBlank ? nil : self
	}
}
