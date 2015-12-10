#! /bin/sh
curl -F files[/SRG\ IL\ DataProvider\ iOS/Localizable.strings]=@SRGIntegrationLayerDataProvider/SRGILDataProviderBundle/en.lproj/Localizable.strings https://api.crowdin.com/api/project/play-srg/update-file?key=$CROWDIN_PLAYSRG_APIKEY
