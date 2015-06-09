source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
workspace 'SRGIntegrationLayerDataProvider.xcworkspace'

### Library project

xcodeproj 'SRGIntegrationLayerDataProvider'

pod 'RTSAnalytics', '0.3.1'
pod 'RTSAnalytics/MediaPlayer', '0.3.1'
pod 'RTSMediaPlayer', '0.2.6'
pod 'RTSOfflineMediaStorage', '~> 0.1.1'

pod 'AFNetworking', '~> 1.3.4'
pod 'SGVReachability', '~> 1.0.0'
pod 'CocoaLumberjack', '~> 2.0.0'
pod 'libextobjc/EXTScope', '0.4.1'

target 'SRGIntegrationLayerDataProviderTests', :exclusive => true do
	pod 'SRGIntegrationLayerDataProvider', :path => '.'
	pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
	pod 'SRGIntegrationLayerDataProvider/OfflineStorage', :path => '.'
end

### Demo project

target 'SRGIntegrationLayerDataProvider Demo', :exclusive => true do
	xcodeproj 'SRGIntegrationLayerDataProvider Demo/SRGIntegrationLayerDataProvider Demo'

	pod 'SRGIntegrationLayerDataProvider', :path => '.'
	pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
end
