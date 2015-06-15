source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
workspace 'SRGIntegrationLayerDataProvider.xcworkspace'

### Library project

xcodeproj 'SRGIntegrationLayerDataProvider'

pod 'RTSAnalytics', '0.3.4'
pod 'RTSAnalytics/MediaPlayer', '0.3.4'
pod 'RTSMediaPlayer', '0.2.9'
pod 'RTSOfflineMediaStorage', '~> 0.1.1'

pod 'AFNetworking', '~> 1.3.4'
pod 'SGVReachability', '~> 1.0.0'
pod 'CocoaLumberjack', '~> 2.0.0'
pod 'libextobjc/EXTScope', '0.4.1'

target 'SRGIntegrationLayerDataProviderTests', :exclusive => true do
    pod 'OCMock', '~> 3.0.0'
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


# See https://github.com/CocoaPods/CocoaPods/issues/2704
# where the 'stdc++' has been stripped to 'c++'

post_install do |installer|
    
    support_files_group = installer.project.support_files_group.groups[0]
    source_tree = File.join(installer.sandbox_root, support_files_group.path)
    
    support_files_group.files.each do |file|
        
        next unless file.path.end_with?('.xcconfig')
        xcconfig_path = File.join(source_tree, file.path)
        xcconfig = File.read(xcconfig_path)
        newXcconfig = xcconfig.gsub(/\ -l"c\+\+"/, '')
        File.open(xcconfig_path, "w") { |file| file << newXcconfig }
        
    end
    
end