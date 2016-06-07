source 'https://github.com/CocoaPods/Specs.git'
source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'

platform :ios, '8.0'
inhibit_all_warnings!

workspace 'SRGIntegrationLayerDataProvider'

# Will be inherited by all targets below
pod 'SRGIntegrationLayerDataProvider', :path => '.'
pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
pod 'SRGIntegrationLayerDataProvider/MediaPlayer/Analytics', :path => '.'

target 'SRGIntegrationLayerDataProvider' do
  target 'SRGIntegrationLayerDataProviderTests' do
    # Test target, inherit search paths only, not linking
    # For more information, see http://blog.cocoapods.org/CocoaPods-1.0-Migration-Guide/
    inherit! :search_paths

    # Target-specific dependencies
    pod 'OCMock', '3.1.2'
    pod 'SRGIntegrationLayerDataProvider/Core', :path => '.'
  end

  xcodeproj 'SRGIntegrationLayerDataProvider.xcodeproj'
end

target 'SRGIntegrationLayerDataProvider Demo' do
  pod 'SDWebImage', '3.7.0'

  target 'SRGIntegrationLayerDataProvider DemoTests' do
    # Test target, inherit search paths only, not linking
    # For more information, see http://blog.cocoapods.org/CocoaPods-1.0-Migration-Guide/
    inherit! :search_paths

    # Target-specific dependencies
    pod 'KIF', '3.4.1'
  end

  xcodeproj 'SRGIntegrationLayerDataProvider Demo/SRGIntegrationLayerDataProvider Demo'
end
