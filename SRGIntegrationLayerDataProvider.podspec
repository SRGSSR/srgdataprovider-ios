Pod::Spec.new do |s|
  s.name = "SRGIntegrationLayerDataProvider"
  s.version = "1.0.8"
  s.summary = "Data Provider using the Integration Layer for the SRG Media Player"
  s.description = <<-DESC
    This is the implementation of the Data Provider using the Integration Layer. It is a generic data provider and it
    is not mandatory to use or have the media player to use the data provider. When used with the media player, it is
    an easy drop in your project. Moreover, an optional module allow you to also use that provider for storing offline
    metadatas from Medias and Shows. It can be used to implement a 'favorites' feature in an app.
DESC
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
    co.source_files         = "SRGIntegrationLayerDataProvider/SRGIntegrationLayerDataProvider.h", "SRGIntegrationLayerDataProvider/Core/*.{h,m}", "SRGIntegrationLayerDataProvider/Model/*.{h,m}", "SRGIntegrationLayerDataProvider/Network/*.{h,m}"
    co.private_header_files = "SRGIntegrationLayerDataProvider/**/*+Private.h"
    co.frameworks           = "Foundation", "UIKit"
    co.dependency             "CocoaLumberjack",  "~> 2.0.0"
    co.dependency             "SGVReachability", "~> 1.0.0"
    co.dependency             "libextobjc/EXTScope", "0.4.1"
  end

  s.subspec 'MediaPlayer' do |mp|
    mp.source_files         = "SRGIntegrationLayerDataProvider/SRGILDataProviderMediaPlayerDataSource.h", "SRGIntegrationLayerDataProvider/MediaPlayer/*.{h,m}", "SRGIntegrationLayerDataProvider/Analytics/*.{h,m}"
    mp.private_header_files = "SRGIntegrationLayerDataProvider/**/*+Private.h"
    mp.frameworks           = "Foundation", "UIKit"
    mp.dependency             "SRGIntegrationLayerDataProvider/Core"
    mp.dependency             "SRGMediaPlayer", "~> 1.1.0"
    mp.dependency             "SRGAnalytics", "~> 1.0.0"
    mp.dependency             "SRGAnalytics/MediaPlayer", "~> 1.0.0"
  end

  s.subspec 'OfflineStorage' do |os|
    os.source_files         = "SRGIntegrationLayerDataProvider/SRGILDataProviderOfflineStorage.h", "SRGIntegrationLayerDataProvider/Offline/*.{h,m}"
    os.private_header_files = "SRGIntegrationLayerDataProvider/Offline/SRGIL*Metadata.{h}"
    os.dependency             "SRGIntegrationLayerDataProvider/Core"
    os.dependency             "SRGOfflineStorage", "~> 1.0.0"
  end

end
