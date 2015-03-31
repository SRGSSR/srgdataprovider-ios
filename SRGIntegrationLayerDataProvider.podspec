Pod::Spec.new do |s|
  s.name = "SRGIntegrationLayerDataProvider"

  s.version = "0.0.1"

  s.summary = "Implementation of the Data Provider using the Integration Layer for the RTS Media Player"

  s.description = "Implementation of the Data Provider using the Integration Layer for the RTS Media Player"

  s.homepage = "http://rts.ch"

  s.license = { :type => "N/A" }

  s.authors = { "Cédric Foellmi" => "cedric.foellmi@hortis.ch", "Cédric Luthi" => "cedric.luthi@rts.ch" }

  s.source = { :git => "git@bitbucket.org:rtsmb/srgintegrationlayerdataprovider-ios.git", :tag => s.version.to_s }

  s.ios.deployment_target = "7.0"

  s.requires_arc = true

  s.source_files = "SRGIntegrationLayerDataProvider"
  s.public_header_files = "SRGIntegrationLayerDataProvider/*.h"
  s.private_header_files = "SRGIntegrationLayerDataProvider/SRGILMedia+Private.h"

  s.frameworks = [ "Foundation", "UIKit" ]

  s.dependency "RTSAnalytics", "~> 0.0.1"
end