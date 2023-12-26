
Pod::Spec.new do |s|
  s.name             = 'LRSwiftyTools'
  s.version          = '0.0.4'
  s.summary          = 'A short description of LRSwiftyTools.'
  s.description      = 'A short description of LRSwiftyTools.'
  s.homepage         = 'https://github.com/huawt/LRSwiftyTools'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huawt' => 'ghost263sky@163.com' }
  s.source           = { :git => 'https://github.com/huawt/LRSwiftyTools.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.source_files = 'LRSwiftyTools/Classes/**/*'
end
