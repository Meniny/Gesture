Pod::Spec.new do |s|
  s.name             = 'Gesture'
  s.version          = '1.0.0'
  s.summary          = 'Better gesture handler for iOS written in Swift'

  s.homepage         = 'https://github.com/Meniny/Gesture'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.authors          = { 'Elias Abel' => 'admin@meniny.cn' }
  s.source           = { :git => 'https://github.com/Meniny/Gesture.git', :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn'
  # s.screenshot       = ''

  s.swift_version    = "4.0"
  s.ios.deployment_target = '8.0'

  s.source_files     = "Gesture/**/*.{swift}"

  s.framework        = 'Foundation', 'UIKit'
  s.module_name      = 'Gesture'
end
