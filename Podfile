source 'https://github.com/CocoaPods/Specs.git'
source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'

inhibit_all_warnings!
platform :ios, '8.0'
workspace 'SRGIntegrationLayerDataProvider.xcworkspace'

### Library project

xcodeproj 'SRGIntegrationLayerDataProvider'

pod 'SRGAnalytics', '~> 1.4.15'
pod 'SRGAnalytics/MediaPlayer'

pod 'SRGMediaPlayer', '~> 1.7.0'

pod 'SGVReachability', '~> 1.0.0'
pod 'CocoaLumberjack', '~> 2.0.0'
pod 'libextobjc/EXTScope', '0.4.1'

target 'SRGIntegrationLayerDataProviderTests', :exclusive => true do
    pod 'OCMock', '3.1.2'
	pod 'SRGIntegrationLayerDataProvider', :path => '.'
	pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
end

### Demo project

target 'SRGIntegrationLayerDataProvider Demo', :exclusive => true do
	xcodeproj 'SRGIntegrationLayerDataProvider Demo/SRGIntegrationLayerDataProvider Demo'
	pod 'SRGIntegrationLayerDataProvider', :path => '.'
	pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
    pod 'SDWebImage', '3.7.0'
end

target 'SRGIntegrationLayerDataProvider DemoTests', :exclusive => true do
    xcodeproj 'SRGIntegrationLayerDataProvider Demo/SRGIntegrationLayerDataProvider Demo'
    pod 'KIF', '3.4.1'
end


post_install do |installer|

    pods_project = installer.respond_to?(:pods_project) ? installer.pods_project : installer.project # Prepare for CocoaPods 0.38.2

    # Set Device family to iPhone/iPad

    pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2' # iPhone, iPad
        end
    end

end
