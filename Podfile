source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
workspace 'SRGIntegrationLayerDataProvider.xcworkspace'

### Library project

xcodeproj 'SRGIntegrationLayerDataProvider'

pod 'SRGAnalytics', '~> 0.5.0'
pod 'SRGAnalytics/MediaPlayer', '~> 0.5.0'
pod 'SRGMediaPlayer', '~> 0.5.1'
pod 'SRGOfflineStorage', '~> 0.4.2'

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

target 'SRGIntegrationLayerDataProvider DemoTests', :exclusive => true do
    xcodeproj 'SRGIntegrationLayerDataProvider Demo/SRGIntegrationLayerDataProvider Demo'
    pod 'KIF', '3.2.1'
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
    
   installer.project.targets.each do |target|
       target.build_configurations.each do |config|
           config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2' # iPhone, iPad
#            config.build_settings['TARGETED_DEVICE_FAMILY'] = '2'
       end
   end
   
end