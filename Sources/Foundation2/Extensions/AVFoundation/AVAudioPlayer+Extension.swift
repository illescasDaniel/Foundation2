//
//  AVAudioPlayer+Extension.swift
//  Foundation2
//
//  Created by Daniel Illescas Romero on 12/07/2018.
//

import AVFoundation

public extension AVAudioPlayer {
	
	public enum AudioTypes: String {
		case mp3
		case wav
		// ...
	}
	
	public convenience init?(file: String, type: AudioTypes, volume: Float? = nil) {
		
		guard let path = Bundle.main.path(forResource: file, ofType: type.rawValue) else { return nil }
		let url = URL(fileURLWithPath: path)
		
		try? self.init(contentsOf: url)
		
		if let validVolume = volume, validVolume >= 0.0 && validVolume <= 1.0 {
			self.volume = validVolume
		}
	}
	
	public func setVolumeLevel(to volume: Float, duration: TimeInterval? = nil) {
		if #available(iOS 10.0, macOS 10.12, *) {
			self.setVolume(volume, fadeDuration: duration ?? 1)
		} else {
			self.volume = volume
		}
	}
}
