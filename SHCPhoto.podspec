
Pod::Spec.new do |s|
  s.name             = 'SHCPhoto'
  s.version          = '0.1.0'
  s.summary          = '图片选择和图片浏览的类'
  s.description      = '提供了图片浏览的放大，缩小，简单的图片选择'

  s.homepage         = 'https://github.com/SHCcc/SHCPhoto'
  s.license          = 'MIT'
  s.author           = { "SHCcc" => "578013836@qq.com" }
  s.ios.deployment_target = '8.0'
  s.source           = { :git => 'https://github.com/SHCcc/SHCPhoto.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.source_files = ['SHCPhoto/**','SHCPhoto/*/**','SHCPhoto/*/*/**']
  s.resource_bundles = { 'Photo' => 'SHCPhoto/Photo.bundle/*.png'}
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.dependency 'Kingfisher'
  s.dependency 'SnapKit'
  s.dependency 'SHCHUD'

end
