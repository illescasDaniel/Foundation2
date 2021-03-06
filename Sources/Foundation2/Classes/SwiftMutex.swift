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

import class Dispatch.DispatchQueue
import class Dispatch.DispatchSemaphore
import class Foundation.NSLock
import typealias Darwin.sys._pthread.pthread_mutex_t
import typealias Darwin.sys._pthread.pthread_mutexattr_t
import func Darwin.sys._pthread.pthread_mutexattr_init
import func Darwin.sys._pthread.pthread_mutex_init
import func Darwin.sys._pthread.pthread_mutexattr_settype
import func Darwin.sys._pthread.pthread_mutexattr_destroy
import func Darwin.sys._pthread.pthread_mutex_destroy
import var Darwin.sys._pthread.PTHREAD_MUTEX_NORMAL
import var Darwin.sys._pthread.PTHREAD_MUTEX_RECURSIVE
import func Darwin.sys._pthread.pthread_mutex_trylock
import func Darwin.sys._pthread.pthread_mutex_unlock

public final class PthreadMutex {
	
	private var unsafeMutex = pthread_mutex_t()
	
	public enum `Type` {
		case normal
		case recursive
	}
	
	public init?(type: PthreadMutex.`Type` = .normal) {
		
		var mutexAttribute = pthread_mutexattr_t()
		
		guard pthread_mutexattr_init(&mutexAttribute) == 0 else {
			return nil
		}
		
		pthread_mutexattr_settype(&mutexAttribute, Int32(type == .normal ? PTHREAD_MUTEX_NORMAL : PTHREAD_MUTEX_RECURSIVE))
		
		guard pthread_mutex_init(&unsafeMutex, &mutexAttribute) == 0 else {
			return nil
		}
		pthread_mutexattr_destroy(&mutexAttribute)
	}
	deinit {
		pthread_mutex_destroy(&unsafeMutex)
	}
	
	public func sync<Type>(execute work: () throws -> Type) -> Type? {
		guard pthread_mutex_trylock(&unsafeMutex) == 0 else { return nil }
		defer { pthread_mutex_unlock(&unsafeMutex) }
		return try? work()
	}
}

public struct Semaphore {
	private let semaphore = DispatchSemaphore(value: 1)
	public func sync<T>(execute work: () throws -> T) -> T? {
		self.semaphore.wait()
		defer { self.semaphore.signal() }
		return try? work()
	}
}

extension NSLock {
	public func sync<T>(execute work: () throws -> T) -> T? {
		self.lock()
		defer { self.unlock() }
		return try? work()
	}
}

