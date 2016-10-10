Pod::Spec.new do |s|
  s.name             = 'GHCircleMenu'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GHCircleMenu.'

  s.homepage         = 'https://github.com/Copperfiled/GHCircleMenu'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Copperfiled' => 'guan.dassy@gmail.com' }
  s.source           = { :git => 'https://github.com/Copperfiled/GHCircleMenu.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GHCircleMenu/Classes/**/*'
  
  s.resource_bundles = {
    'GHCircleMenu' => ['GHCircleMenu/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
