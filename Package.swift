import PackageDescription

let package = Package(
    name: "ReactiveAlamofire",
    dependencies: [
        .Package(url: "https://github.com/ReactiveKit/ReactiveKit.git", majorVersion: 3),
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4, minor: 2)
    ]
)
