#
# Be sure to run `pod lib lint Orchextra.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GIGLibrary'
  s.version          = '3.1.3'
  s.summary          = 'Main library for Gigigo iOS projects.'
  s.swift_version    = '4.2.0'

  s.description      = <<-DESC
# What is included
- GIGNetwork: classes to manage network requests.
- SwiftNetwork: Swift classes to manage gigigo's requestst. Standard Gigigo JSON is parsed by default.
- GIGLayout: some functions to help with autolayout.
- GIGUtils: a lot of extensions on foundation classes.
- GIGScanner: QR scanner using native iOS API
- GIGLocation: Wrapper on CLLocation API
- SlideMenu: A basic lateral slide menu
- ProgressPageControl: A page control with a progress bar in the selected page.
                       DESC

  s.homepage         = 'https://github.com/gigigoapps/gigigo-ios-lib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jcarlosestela' => 'jose.estela@gigigo.com' }
  s.source           = { :git => 'https://github.com/gigigoapps/gigigo-ios-lib.git', :tag => 'v' + s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/**/*.{h,m,swift}'

end
