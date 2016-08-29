Pod::Spec.new do |s|
  s.name             = "AlamofireReactive"
  s.version          = "2.0.0-beta1"
  s.summary          = "Reactive extensions for Alamofire framework."
  s.homepage         = "https://github.com/ReactiveKit/ReactiveAlamofire"
  s.license          = 'MIT'
  s.author           = { "Srdan Rasic" => "srdan.rasic@gmail.com" }
  s.source           = { :git => "https://github.com/ReactiveKit/ReactiveAlamofire.git", :tag => "v2.0.0-beta1" }
  s.module_name      = 'ReactiveAlamofire'

  s.ios.deployment_target       = '9.0'
  s.osx.deployment_target       = '10.11'
  s.watchos.deployment_target   = '2.0'
  s.tvos.deployment_target      = '9.0'

  s.source_files      = 'Sources/*.swift', 'ReactiveAlamofire/*.h'
  s.requires_arc      = true

  s.dependency 'ReactiveKit', '~> 3.0.0-beta1'
  s.dependency 'Alamofire', '4.0.0-beta.1'
end
