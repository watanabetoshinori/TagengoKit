Pod::Spec.new do |s|
  s.name = 'TagengoKit'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'NICT Tagengo Sandbox API for iOS'
  s.homepage = 'https://github.com/watanabetoshinori/TagengoKit'
  s.author = "Watanabe Toshinori"
  s.source = { :git => 'https://github.com/watanabetoshinori/TagengoKit.git', :tag => s.version }

  s.ios.deployment_target = '12.0'

  s.source_files = 'Source/**/*.{h,swift}'
  s.resources = 'Source/**/*.{xib,storyboard}', 'Source/**/*.xcassets'

end
