Pod::Spec.new do |s|
  s.name             = "AlamofireReactive"
  s.version          = "1.0.2"
  s.summary          = "Reactive extensions for Alamofire framework."
  s.homepage         = "https://github.com/ReactiveKit/ReactiveAlamofire"
  s.license          = 'MIT'
  s.author           = { "Srdan Rasic" => "srdan.rasic@gmail.com" }
  s.source           = { :git => "https://github.com/ReactiveKit/ReactiveAlamofire.git", :tag => "v1.0.2" }
  s.module_name      = 'ReactiveAlamofire'

  s.ios.deployment_target       = '8.0'
  s.osx.deployment_target       = '10.9'
  s.watchos.deployment_target   = '2.0'
  s.tvos.deployment_target      = '9.0'

  s.source_files      = 'Sources/*.swift', 'ReactiveAlamofire/*.h'
  s.requires_arc      = true

  s.dependency 'ReactiveKit', '~> 2.0'
  s.dependency 'Alamofire', '~> 3.3'
end
