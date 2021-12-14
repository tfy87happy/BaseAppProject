#
# Be sure to run `pod lib lint BaseAppProject.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BaseAppProject'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BaseAppProject.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/thb87happy/BaseAppProject'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'thb87happy' => 'tanghaobo@evergrande.cn' }
  s.source           = { :git => 'https://github.com/thb87happy/BaseAppProject.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BaseAppProject/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BaseAppProject' => ['BaseAppProject/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 4.0.1'
  s.dependency 'SDWebImage'
  s.dependency 'YYKit'
  s.dependency 'MJRefresh'
  s.dependency 'Masonry'
  s.dependency 'TTTAttributedLabel'
  s.dependency 'MBProgressHUD'
  s.dependency 'SDCycleScrollView'
  s.dependency 'IQKeyboardManager'
  s.dependency 'UICKeyChainStore'
  s.dependency 'XHLaunchAd', '~> 3.9.12'
  s.dependency 'CYLTabBarController', '~> 1.29.0'
  s.dependency 'QMUIKit'
  
#  s.prefix_header_contents = <<-EOS
#  #ifdef __OBJC__
#  #import <Masonry/Masonry.h>
#  #endif /* __OBJC__*/
#  EOS
end
