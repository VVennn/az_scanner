#
# Be sure to run `pod lib lint az_scanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'az_scanner'
  s.version          = '1.1.2'
  s.summary          = 'A short description of az_scanner.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/VVennn/az_scanner'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Az' => 'vvennnnnnnn@gmail.com' }
  s.source           = { :git => 'https://github.com/VVennn/az_scanner.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '11.0'

  s.source_files = 'az_scanner/Classes/**/*'
#  s.ios.vendored_frameworks = 'az_scanner/frameworks/*'
#  s.resources = [
#    'az_scanner/bundle/*'
#  ]
  # s.resource_bundles = {
  #   'az_scanner' => ['az_scanner/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'ScanKitFrameWork'#, '=1.0.0.300'
  s.pod_target_xcconfig = {'VALID_ARCHS' => 'x86_64 armv7 arm64'}

end
