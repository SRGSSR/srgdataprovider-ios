Pod::Spec.new do |s|
  s.name = "SRGIntegrationLayerDataProvider"
  s.version = "0.0.2"
  s.summary = "Implementation of the Data Provider using the Integration Layer for the RTS Media Player"
  s.description = "Implementation of the Data Provider using the Integration Layer for the RTS Media Player"
  s.homepage = "http://rts.ch"
  s.license = { :type => "N/A" }
  s.authors = { "Cédric Foellmi" => "cedric.foellmi@hortis.ch", "Cédric Luthi" => "cedric.luthi@rts.ch" }
  s.source = { :git => "git@bitbucket.org:rtsmb/srgintegrationlayerdataprovider-ios.git", :tag => s.version.to_s }

  # Platform setup
  s.ios.deployment_target = "7.0"
  s.requires_arc = true

  # Exclude optional Stream Measurement modules
  s.default_subspec = 'Core'

  ### Subspecs

  s.subspec 'Core' do |co|
    co.source_files         = "SRGIntegrationLayerDataProvider/SRGIntegrationLayerDataProvider.h", "SRGIntegrationLayerDataProvider/Core/*.{h,m}", "SRGIntegrationLayerDataProvider/Model/*.{h,m}", "SRGIntegrationLayerDataProvider/Network/*.{h,m}", "SRGIntegrationLayerDataProvider/Analytics/*.{h,m}"
    co.private_header_files = "SRGIntegrationLayerDataProvider/**/*+Private.h"
    co.frameworks           = "Foundation", "UIKit"
    co.dependency             "CocoaLumberjack",  "~> 2.0.0"
  end

  s.subspec 'OfflineStorage' do |os|
    os.source_files         = "SRGIntegrationLayerDataProvider/SRGILOfflineMetadataProvider.h", "SRGIntegrationLayerDataProvider/Offline/*.{h,m}"
    os.private_header_files = "SRGIntegrationLayerDataProvider/Offline/SRGILMediaMetadata.{h,m}"
    os.dependency             "RTSOfflineMediaStorage", "~> 0.0.2"
  end

end