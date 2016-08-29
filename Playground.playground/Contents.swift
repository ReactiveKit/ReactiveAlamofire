//: Playground - noun: a place where people can play

import Alamofire
import ReactiveKit
import ReactiveAlamofire
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let request = Alamofire.request("https://httpbin.org/get", withMethod: .get, parameters: ["foo": "bar"])

request.toJSONSignal().observeNext { json in
  print(json)
}


let streamRequest = Alamofire.request("http://httpbin.org/stream/3", withMethod: .get)

streamRequest.toJSONStreamingSignal().observeNext { json in
  print("stream part: \(json)")
}
