Pod::Spec.new do |s|

  s.name = 'SPQRCode'
  s.version = '1.0.1'
  s.summary = 'The native QR code scanner of iOS. Repeated system scanner from the camera app.'
  s.homepage = 'https://github.com/sparrowcode/SPQRCode'
  s.source = { :git => 'https://github.com/sparrowcode/SPQRCode.git', :tag => s.version }
  s.license = { :type => 'MIT', :file => "LICENSE" }
  s.author = { 'Ivan Vorobei' => 'hello@ivanvorobei.io' }
  
  s.swift_version = '5.1'
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'

  s.source_files  = 'Sources/SPQRCode/**/*.swift'
  
  s.default_subspec = 'Core'

  s.subspec 'Core' do |subspec|
    subspec.source_files  = "Sources/SPQRCode/**/*.swift"
    subspec.pod_target_xcconfig = {
        "SWIFT_ACTIVE_COMPILATION_CONDITIONS"  => "SPPQRCODE_COCOAPODS"
    }
    subspec.resource_bundles = {
        "SPQRCode" => [
            "Sources/SPQRCode/Resources/Localization/*.lproj/*.strings",
            "Sources/SPQRCode/Resources/Assets.xcassets",
        ]
    }
  end

end
