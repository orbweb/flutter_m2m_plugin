#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint m2m_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'm2m_plugin'
  s.version          = '1.0.0+1'
  s.summary          = 'Orbweb m2m connect plugin project.'
  s.description      = <<-DESC
Orbweb m2m connect plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  #s.source           = { :git => 'https://github.com/orbweb/M2MKit-iOS.git' , :tag => '0.1.0' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  #s.dependency 'M2MKit', :git => 'https://github.com/orbweb/M2MKit-iOS.git'
  s.preserve_paths = 'Frameworks/*.framework'
  s.vendored_frameworks = 'Frameworks/M2MKit.framework'
  s.xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '"$(PODS_ROOT)/Frameworks/"' }

  s.libraries = "bz2", "z", "c++", "iconv", "resolv.9"
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
