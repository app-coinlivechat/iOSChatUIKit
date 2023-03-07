#
# Be sure to run `pod lib lint CoinliveChatUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CoinliveChatUIKit'
  s.version          = '0.0.3'
  s.summary          = 'A UIKit in Chat solution by Coinlive'
  s.swift_version    = '5.0'

  s.description      = 'If you consider using uikit or sdk you must receive api key from Coinlive.'

  s.homepage         = 'https://github.com/app-coinlivechat'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Parkjonghyun93' => 'kltb930906@gmail.com' }
  s.source           = { :git => 'https://github.com/app-coinlivechat/iOSChatUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'CoinliveChatUIKit/Classes/**/*'
end
