Pod::Spec.new do |s|
  s.name             = "XLMediaZoom"
  s.version          = "3.0.0"
  s.summary          = "UI controls to view an image or reproduce a video in fullscreen."
  s.homepage         = "https://github.com/xmartlabs/XLMediaZoom"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "Xmartlabs SRL" => "swift@xmartlabs.com" }
  s.source           = { git: "https://github.com/xmartlabs/XLMediaZoom.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/xmartlabs'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.ios.source_files = ['Sources/**/*.xib', 'Sources/**/*.{swift}']
  s.ios.frameworks = 'UIKit', 'Foundation'
end
