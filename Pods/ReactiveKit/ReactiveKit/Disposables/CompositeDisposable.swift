//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Srdan Rasic (@srdanrasic)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// A disposable that disposes a collection of disposables upon disposing.
public final class CompositeDisposable: DisposableType {
  
  public private(set) var isDisposed: Bool = false
  private var disposables: [DisposableType] = []
  private let lock = RecursiveLock(name: "com.ReactiveKit.ReactiveKit.CompositeDisposable")
  
  public convenience init() {
    self.init([])
  }
  
  public init(_ disposables: [DisposableType]) {
    self.disposables = disposables
  }
  
  public func addDisposable(disposable: DisposableType) {
    lock.lock()
    if isDisposed {
      disposable.dispose()
    } else {
      disposables.append(disposable)
      self.disposables = disposables.filter { $0.isDisposed == false }
    }
    lock.unlock()
  }
  
  public func dispose() {
    lock.lock()
    isDisposed = true
    for disposable in disposables {
      disposable.dispose()
    }
    disposables = []
    lock.unlock()
  }
}

public func += (left: CompositeDisposable, right: DisposableType) {
  left.addDisposable(right)
}