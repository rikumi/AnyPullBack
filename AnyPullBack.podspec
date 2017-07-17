#
#  Be sure to run `pod spec lint AnyPullBack.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "AnyPullBack"
  s.version      = "1.0.0"
  s.summary      = "Swipe right/down/up to go back in the simple Navigation Controller"
  s.description  = <<-DESC
  				   
A simple Navigation Controller, with transitions to push a View Controller with animation, and to enable swipe right/down/up gestures to pop the current View Controller.

                   DESC

  s.homepage     = "https://github.com/vhyme/AnyPullBack"
  s.license      = "MIT"
  s.author             = { "Vhyme Riku" => "vhyme@live.cn" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/vhyme/AnyPullBack.git", :tag => "#{s.version}" }
  s.source_files  = "AnyPullBack/**/*.{swift}"

end
