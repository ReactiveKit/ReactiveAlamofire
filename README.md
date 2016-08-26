# ReactiveAlamofire
Reactive extensions for Alamofire framework

# Extensions

```swift
extension Request {

  // General

  public func toSignal() -> Signal<(URLRequest?, HTTPURLResponse?, Data?), NSError>

  public func toSignal<S: ResponseSerializerType>(_ responseSerializer: S) -> Signal<S.SerializedObject, S.ErrorObject>

  public func toDataSignal() -> Signal<Data, NSError>

  public func toStringSignal(encoding encoding: String.Encoding? = nil) -> Signal<String, NSError>

  public func toJSONSignal(options options: JSONSerialization.ReadingOptions = .allowFragments) -> Signal<Any, NSError>

  public func toPropertyListSignal(options options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Signal<Any, NSError>

  // Streaming

  public func toStreamingSignal() -> Signal<Data, NSError>

  public func toStringStreamingSignal(elimiter: String, encoding: String.Encoding = .utf8) -> Signal<String, NSError>

  public func toJSONStreamingSignal(delimiter: String = "\n", encoding: String.Encoding = .utf8, options: JSONSerialization.ReadingOptions = .allowFragments) -> Signal<Any, NSError>
}
```

## Installation

### CocoaPods

```
pod 'AlamofireReactive', '~> 2.0.0-beta1'
```

> Although framework is named ReactiveAlamofire, such name is already occupied on CocoaPods so we use alternative. You still import `ReactiveAlamofire` in your code.

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
