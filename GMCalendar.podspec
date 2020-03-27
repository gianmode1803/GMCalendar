#
# Be sure to run `pod lib lint GMCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GMCalendar'
  s.version          = '1.7'
  s.summary          = 'Easy customizable Calendar for swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'GMCalendar is a customizable Calendar Pod written in swift that can help if you need to use a simple and easy Calendar on Swift.'

  s.homepage         = 'https://github.com/gianmode1803/GMCalendar.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gianmode1803@hotmail.com' => 'gianmode1803@hotmail.com' }
  s.source           = { :git => 'https://github.com/gianmode1803/GMCalendar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gianmode'

  s.ios.deployment_target = '13.2'
  s.swift_version = '5.0'
  s.source_files = 'GMCalendar/Classes/**/*'
  s.requires_arc = true
  s.resource_bundles = {
    'GMCalendar' => ['GMCalendar/Assets/*.png']
  }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  #s.frameworks = 'UIKit', 'MapKit', 'GMCalendar'
  # s.dependency 'AFNetworking', '~> 2.3'
end
