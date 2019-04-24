#
# Be sure to run `pod lib lint AHProvider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AHProvider'
  s.version          = '0.2.0'
  s.summary          = 'AHProvider library to make API requests.'

  s.homepage         = 'https://github.com/Arohak/AHProvider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arohak' => 'aro.hak.25@gmail.com' }
  s.source           = { :git => 'https://github.com/Arohak/AHProvider.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'AHProvider/Classes/**/*'
  s.frameworks = 'UIKit', 'Foundation'

end
