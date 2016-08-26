//: Playground - noun: a place where people can play

import Alamofire
import ReactiveKit
import ReactiveAlamofire
import XCPlayground

XCPlayground.XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let request = Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])

request.toJSONSignal().observeNext { json in
  print(json)
}


let streamRequest = Alamofire.request(.GET, "http://httpbin.org/stream/3")

streamRequest.toJSONStreamingSignal().observeNext { json in
  print("stream part: \(json)")
}
