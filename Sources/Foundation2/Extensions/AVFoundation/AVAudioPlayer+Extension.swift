/*
The MIT License (MIT)

Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel>

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

import class AVFoundation.AVFAudio.AVAudioPlayer
import class Foundation.NSBundle.Bundle
import struct Foundation.URL
import struct Foundation.TimeInterval

public extension AVAudioPlayer {
	
	public enum AudioTypes: String {
		case mp3
		case wav
		case m4a
		case aac
		case ac3
		case adts
		case aif
		case aiff
		case aifc
		case caf
		// ... ?
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
