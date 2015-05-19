Pod::Spec.new do |s|
  s.name = "SRGIntegrationLayerDataProvider"
  s.version = "0.1.0"
  s.summary = "Implementation of the Data Provider using the Integration Layer for the RTS Media Player"
  s.description = "Implementation of the Data Provider using the Integration Layer for the RTS Media Player"
  s.homepage = "http://rts.ch"
  s.license = { :type => "N/A" }
  s.authors = { "Cédric Foellmi" => "cedric.foellmi@hortis.ch", "Cédric Luthi" => "cedric.luthi@rts.ch" }
  s.source = { :git => "git@bitbucket.org:rtsmb/srgintegrationlayerdataprovider-ios.git", :tag => s.version.to_s }

  # Platform setup
  s.platform = :ios
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
    co.dependency             "AFNetworking", "~> 1.3.4"
    co.dependency             "SGVReachability", "~> 1.0.0"
    co.dependency             "libextobjc/EXTScope", "0.4.1"
    co.dependency             "RTSAnalytics", "~> 0.1.0"
  end

  s.subspec 'MediaPlayer' do |mp|
    mp.source_files         = "SRGIntegrationLayerDataProvider/SRGILDataProviderMediaPlayerDataSource.h", "SRGIntegrationLayerDataProvider/MediaPlayer/*.{h,m}"
    mp.private_header_files = "SRGIntegrationLayerDataProvider/**/*+Private.h"
    mp.frameworks           = "Foundation", "UIKit"
    mp.dependency             "SRGIntegrationLayerDataProvider/Core"
    mp.dependency             "RTSAnalytics/MediaPlayer", "~> 0.1.0"
    mp.dependency             "RTSMediaPlayer", "~> 0.0.3"
  end

  s.subspec 'OfflineStorage' do |os|
    os.source_files         = "SRGIntegrationLayerDataProvider/SRGILDataProviderOfflineStorage.h", "SRGIntegrationLayerDataProvider/Offline/*.{h,m}"
    os.private_header_files = "SRGIntegrationLayerDataProvider/Offline/SRGIL*Metadata.{h,m}"
    os.dependency             "SRGIntegrationLayerDataProvider/Core"
    os.dependency             "RTSOfflineMediaStorage", "~> 0.1.0"
  end

end
