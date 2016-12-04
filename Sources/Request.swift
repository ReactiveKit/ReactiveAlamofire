//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Srdan Rasic (@srdanrasic)
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

import Alamofire
import ReactiveKit

extension DataRequest {

  public func toSignal() -> Signal<(URLRequest?, HTTPURLResponse?, Data?), NSError> {
    return Signal { observer in

      let request = self .response { response in
        if let error = response.error {
          observer.failed(error as NSError)
        } else {
          observer.next(response.request, response.response, response.data)
          observer.completed()
        }
      }

      request.resume()

      return BlockDisposable {
        request.cancel()
      }
    }
  }

  public func toSignal<S: DataResponseSerializerProtocol>(_ responseSerializer: S) -> Signal<S.SerializedObject, NSError> {
    return Signal { observer in

      let request = self.response(responseSerializer: responseSerializer) { response in
        switch response.result {
        case .success(let value):
          observer.next(value)
          observer.completed()
        case .failure(let error):
          observer.failed(error as NSError)
        }
      }

      request.resume()

      return BlockDisposable {
        request.cancel()
      }
    }
  }

  public func toDataSignal() -> Signal<Data, NSError> {
    return toSignal(DataRequest.dataResponseSerializer())
  }

  public func toStringSignal(encoding: String.Encoding? = nil) -> Signal<String, NSError> {
    return toSignal(DataRequest.stringResponseSerializer(encoding: encoding))
  }

  public func toJSONSignal(options: JSONSerialization.ReadingOptions = .allowFragments) -> Signal<Any, NSError> {
    return toSignal(DataRequest.jsonResponseSerializer(options: options))
  }

  public func toPropertyListSignal(options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> Signal<Any, NSError> {
    return toSignal(DataRequest.propertyListResponseSerializer(options: options))
  }
}

/// Streaming API

extension DataRequest {

  public func toStreamingSignal() -> Signal<Data, NSError> {
    return Signal { observer in

      let request = self
        .stream { data in
          observer.next(data)
        }.response { response in
          if let error = response.error {
            observer.failed(error as NSError)
          } else {
            observer.completed()
          }
      }

      request.resume()

      return BlockDisposable {
        request.cancel()
      }
    }
  }

//  public func toStringStreamingSignal(delimiter: String, encoding: String.Encoding = .utf8) -> Signal<String, NSError> {
//    return toSignal()
//      .tryMap { data -> ReactiveKit.Result<String, NSError> in
//        if let string = String(data: data, encoding: encoding) {
//          return .success(string)
//        } else {
//          return .failure(NSError(domain: "toStringStreamingSignal: Could not decode string!", code: 0, userInfo: nil))
//        }
//      }
//      .flatMapLatest { string in
//        Signal<String, NSError>.sequence(string.characters.map { String($0) })
//      }
//      .split { character in
//        character == delimiter
//      }
//      .map {
//        $0.joined(separator: "")
//    }
//  }
//
//  public func toJSONStreamingSignal(delimiter: String = "\n", encoding: String.Encoding = .utf8, options: JSONSerialization.ReadingOptions = .allowFragments) -> Signal<Any, NSError> {
//    return toStringStreamingSignal(delimiter: delimiter, encoding: encoding)
//      .map { message in
//        message.trimmingCharacters(in: .whitespacesAndNewlines)
//      }
//      .filter { message in
//        !message.isEmpty
//      }
//      .tryMap { message -> ReactiveKit.Result<Any, NSError> in
//        do {
//          guard let data = message.data(using: encoding) else {
//            return .failure(NSError(domain: "toJSONStreamingSignal: Could not encode string!", code: 0, userInfo: nil))
//          }
//          let json = try JSONSerialization.jsonObject(with: data, options: options)
//          return .success(json)
//        } catch {
//          return .failure(error as NSError)
//        }
//    }
//  }
}

extension SignalProtocol {

  public func split(_ isDelimiter: @escaping (Element) -> Bool) -> Signal<[Element], Error> {
    return Signal { observer in
      var buffer: [Element] = []
      return self.observe { event in
        switch event {
        case .next(let element):
          if isDelimiter(element) {
            observer.next(buffer)
            buffer.removeAll()
          } else {
            buffer.append(element)
          }
        case .completed:
          observer.completed()
        case .failed(let error):
          observer.failed(error)
        }
      }
    }
  }
}
