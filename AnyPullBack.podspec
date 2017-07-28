Pod::Spec.new do |s|
  s.name         = "AnyPullBack"
  s.version      = "1.1.8"
  s.summary      = "Swipe right/down/up to go back in the simple Navigation Controller"
  s.homepage     = "https://github.com/vhyme/AnyPullBack"
  s.license      = "MIT"
  s.author       = { "Vhyme Riku" => "vhyme@live.cn" }
  s.source       = { :git => "https://github.com/vhyme/AnyPullBack.git", :tag => "#{s.version}" }
  s.documentation_url = "https://github.com/vhyme/AnyPullBack"
  s.platform     = :ios, "8.0"
  s.source_files = "AnyPullBack"
  s.framework    = "UIKit"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
end
