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

extension Request {

  public func toOperation() -> Operation<(NSURLRequest?, NSHTTPURLResponse?, NSData?), NSError> {
    return Operation { observer in

      let request = self.response() { (request, response, data, error) in
        if let error = error {
          observer.failure(error)
        } else {
          observer.next(request, response, data)
          observer.completed()
        }
      }

      request.resume()

      return BlockDisposable {
        request.cancel()
      }
    }
  }

  public func toOperation<S: ResponseSerializerType>(responseSerializer: S) -> Operation<S.SerializedObject, S.ErrorObject> {
    return Operation { observer in

      let request = self.response(responseSerializer: responseSerializer) { response in
        switch response.result {
        case .Success(let value):
          observer.next(value)
          observer.completed()
        case .Failure(let error):
          observer.failure(error)
        }
      }

      request.resume()

      return BlockDisposable {
        request.cancel()
      }
    }
  }

  public func toDataOperation() -> Operation<NSData, NSError> {
    return toOperation(Request.dataResponseSerializer())
  }

  public func toStringOperation(encoding encoding: NSStringEncoding? = nil) -> Operation<String, NSError> {
    return toOperation(Request.stringResponseSerializer(encoding: encoding))
  }

  public func toJSONOperation(options options: NSJSONReadingOptions = .AllowFragments) -> Operation<AnyObject, NSError> {
    return toOperation(Request.JSONResponseSerializer(options: options))
  }

  public func toPropertyListOperation(options options: NSPropertyListReadOptions = NSPropertyListReadOptions()) -> Operation<AnyObject, NSError> {
    return toOperation(Request.propertyListResponseSerializer(options: options))
  }
}

/// Streaming API

extension Request {

  public func toStreamingOperation() -> Operation<NSData, NSError> {
    return Operation { observer in

      let request = self
        .stream { data in
          observer.next(data)
        }.response() { (_, _, _, error) in
          if let error = error {
            observer.failure(error)
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

  public func toStringStreamingOperation(delimiter delimiter: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Operation<String, NSError> {
    return toStreamingOperation()
      .tryMap { data -> ReactiveKit.Result<String, NSError> in
        if let string = String(data: data, encoding: encoding) {
          return .Success(string)
        } else {
          return .Failure(NSError(domain: "toStringStreamingOperation: Could not decode string!", code: 0, userInfo: nil))
        }
      }
      .flatMap(.Latest) { string in
        Operation<String, NSError>.sequence(string.characters.map { String($0) })
      }
      .split { character in
        character == delimiter
      }
      .map {
        $0.joinWithSeparator("")
    }
  }

  public func toJSONStreamingOperation(delimiter delimiter: String = "\n", encoding: NSStringEncoding = NSUTF8StringEncoding, options: NSJSONReadingOptions = .AllowFragments) -> Operation<AnyObject, NSError> {
    return toStringStreamingOperation(delimiter: delimiter, encoding: encoding)
      .map { message in
        message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      }
      .filter { message in
        !message.isEmpty
      }
      .tryMap { message -> ReactiveKit.Result<AnyObject, NSError> in
        do {
          guard let data = message.dataUsingEncoding(encoding) else {
            return .Failure(NSError(domain: "toJSONStreamingOperation: Could not encode string!", code: 0, userInfo: nil))
          }
          let json = try NSJSONSerialization.JSONObjectWithData(data, options: options)
          return .Success(json)
        } catch {
          return .Failure(error as NSError)
        }
    }
  }
}

extension OperationType {

  @warn_unused_result
  public func split(isDelimiter: Element -> Bool) -> Operation<[Element], Error> {
    return Operation { observer in
      var buffer: [Element] = []
      return self.observe { event in
        switch event {
        case .Next(let element):
          if isDelimiter(element) {
            observer.next(buffer)
            buffer.removeAll()
          } else {
            buffer.append(element)
          }
        case .Completed:
          observer.completed()
        case .Failure(let error):
          observer.failure(error)
        }
      }
    }
  }
}
