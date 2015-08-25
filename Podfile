source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
platform :ios, '7.0'
workspace 'SRGIntegrationLayerDataProvider.xcworkspace'

### Library project

xcodeproj 'SRGIntegrationLayerDataProvider'

pod 'SRGAnalytics', '~> 1.0.0'
pod 'SRGAnalytics/MediaPlayer'

pod 'SRGMediaPlayer', '~> 1.1.0'
#pod 'SRGOfflineStorage', :path => '../srgofflinestorage-ios/'
pod  'SRGOfflineStorage', '~> 1.2.1'

pod 'SGVReachability', '~> 1.0.0'
pod 'CocoaLumberjack', '~> 2.0.0'
pod 'libextobjc/EXTScope', '0.4.1'

target 'SRGIntegrationLayerDataProviderTests', :exclusive => true do
    pod 'OCMock', '3.1.2'
	pod 'SRGIntegrationLayerDataProvider', :path => '.'
	pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
	pod 'SRGIntegrationLayerDataProvider/OfflineStorage', :path => '.'
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
    pod 'KIF', '3.2.1'
end


post_install do |installer|
    
    pods_project = installer.respond_to?(:pods_project) ? installer.pods_project : installer.project # Prepare for CocoaPods 0.38.2
    
    # See https://github.com/CocoaPods/CocoaPods/issues/2704
    # where the 'stdc++' has been stripped to 'c++' / Fixed with CocoaPods 0.38.2
    
    support_files_group = installer.project.support_files_group.groups[0]
    source_tree = File.join(installer.sandbox_root, support_files_group.path)
    
    support_files_group.files.each do |file|
        
        next unless file.path.end_with?('.xcconfig')
        xcconfig_path = File.join(source_tree, file.path)
        xcconfig = File.read(xcconfig_path)
        newXcconfig = xcconfig.gsub(/\ -l"c\+\+"/, '')
        File.open(xcconfig_path, "w") { |file| file << newXcconfig }
        
    end
    
    # Set Device family to iPhone/iPad
    
    pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2' # iPhone, iPad
        end
    end
    
end