#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint baidu_map.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'baidu_map'
  s.version          = '0.0.1'
  s.summary          = 'Baidu Map for flutter'
  s.homepage         = 'https://github.com/qiuxiang/flutter-baidu-map'
  s.license          = { :file => '../LICENSE' }
  s.author           = { '7c00' => 'i@7c00.cc' }
  s.source           = { :path => '.' }
  s.source_files = '**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
