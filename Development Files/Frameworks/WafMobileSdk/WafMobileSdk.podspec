Pod::Spec.new do |s|
  s.name         = "WafMobileSdk"
  s.version      = "0.0.4"
  s.summary      = "WafMobileSdk"
  s.description  = <<-DESC
    WAF Mobile SDK for iOS
  DESC

  s.homepage     = "https://code.amazon.com"
  s.license      = "Amazon Internal"
  s.author       = { "WAF" => "waf@amazon.com" }
  s.source       = { :http => 'file:' + __dir__ + '/WafMobileSdk.zip' }
  s.vendored_frameworks = 'WafMobileSdk.xcframework'
  s.static_framework = true
  
  s.ios.deployment_target = "13.0"
    
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'armv7' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'armv7' }
  
  s.dependency 'Argon2Swift', '~> 1.0.1'
end
