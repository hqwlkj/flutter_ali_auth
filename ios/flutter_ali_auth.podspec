#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_ali_auth.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ali_auth'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Ali Auth Plugin 阿里云一键登录Flutter插件'
  s.description      = <<-DESC
Flutter Ali Auth Plugin 阿里云一键登录Flutter插件
                       DESC
  s.homepage         = 'https://github.com/fluttercandies/flutter_ali_auth'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'kangkang' => 'kangkanglaile1205@163.com' }
  s.source           = { :path => '.' }

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'Flutter'
  s.dependency 'SDWebImage'
  s.dependency 'MJExtension'
  s.dependency 'MBProgressHUD'

  s.platform = :ios, '12.0'

  s.vendored_frameworks = 'xcframeworks/*.xcframework'
  s.framework = 'Network'
  s.resource = 'xcframeworks/ATAuthSDK.xcframework/ios-arm64/ATAuthSDK.framework/ATAuthSDK.bundle'

  s.xcconfig = {
#     'OTHER_LDFLAGS' => '-ObjC',
    'ENABLE_BITCODE' => 'NO'
  }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
