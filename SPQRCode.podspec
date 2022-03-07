Pod::Spec.new do |s|

  s.name = 'SPQRCode'
  s.version = '1.0.0'
  s.summary = 'QRCode detector'
  s.homepage = 'https://github.com/sparrowcode/SPQRCode'
  s.source = { :git => 'https://github.com/sparrowcode/SPQRCode.git', :tag => s.version }
  s.license = { :type => 'MIT', :file => "LICENSE" }
  s.author = { 'Ivan Vorobei' => 'hello@ivanvorobei.io' }
  
  s.swift_version = '5.1'
  s.ios.deployment_target = '11.0'

  s.source_files  = 'Sources/SPQRCode/**/*.swift'

end
