# ReactiveAlamofire
Reactive extensions for Alamofire framework

# Extensions

```swift
extension Request {

  // General

  public func toOperation() -> Operation<(NSURLRequest?, NSHTTPURLResponse?, NSData?), NSError>
  
  public func toOperation<S: ResponseSerializerType>(responseSerializer: S) -> Operation<S.SerializedObject, S.ErrorObject>

  public func toDataOperation() -> Operation<NSData, NSError>

  public func toStringOperation(encoding encoding: NSStringEncoding? = nil) -> Operation<String, NSError>

  public func toJSONOperation(options options: NSJSONReadingOptions = .AllowFragments) -> Operation<AnyObject, NSError>

  public func toPropertyListOperation(options options: NSPropertyListReadOptions = NSPropertyListReadOptions()) -> Operation<AnyObject, NSError>

  // Streaming

  public func toStreamingOperation() -> Operation<NSData, NSError>

  public func toStringStreamingOperation(delimiter delimiter: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Operation<String, NSError>

  public func toJSONStreamingOperation(delimiter delimiter: String = "\n", encoding: NSStringEncoding = NSUTF8StringEncoding, options: NSJSONReadingOptions = .AllowFragments) -> Operation<AnyObject, NSError>
}
```

## Installation

### CocoaPods

```
pod 'ReactiveAlamofire', '~> 1.0'
```

### Carthage

```
github "ReactiveKit/ReactiveAlamofire" ~> 2.0
```

## License

The MIT License (MIT)

Copyright (c) 2015-2016 Srdan Rasic (@srdanrasic)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
