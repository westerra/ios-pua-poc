== Installation of WAF Mobile SDK to local Cocoapods ==

1. Create a new directory for storing local WafMobileSdk pod (ex: ~/cocoapods/WafMobileSdk)
2. Unzip/untar the `WafMobileSdk` archive and move WafMobileSdk.podspec and WafMobileSdk.xcframework to the newly created directory 
3. Modify existing Podfile by adding WafMobileSdk pod dependency (ex: pod 'WafMobileSdk', :path => '~/cocoapods/WafMobileSdk')
4. Run pod install and open app's xcworkspace


Additional notes :
- To support statically-linked library in CocoaPods, one can use "use_frameworks! :linkage => :static" 
- It's recommended to enable "Build Libraries for Distribution" and set NO to build only active arch. To do this in Podfile,

```
  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
  end
```
