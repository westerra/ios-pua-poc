platform :ios, '15.0'

plugin 'cocoapods-art', sources: %w[
  backbase-pods3
  backbase-pods-business
  backbase-pods-design-system
  backbase-pods-engagement-channels
  backbase-pods-flow
  backbase-pods-identity
  backbase-pods-mitek-misnap
  backbase-pods-notifications
  backbase-pods-retail3
]

install! 'cocoapods', deterministic_uuids: false, warn_for_unused_master_specs_repo: false
source 'https://cdn.cocoapods.org/'

use_frameworks!
inhibit_all_warnings!

abstract_target 'Common' do

  pod 'AppCenter',            '5.0.2'
  pod 'Firebase',             '10.28.0'
  pod 'FirebaseAnalytics',    '10.28.0'
  pod 'FirebaseCore',         '10.28.0'
  pod 'FirebaseCrashlytics',  '10.28.1'
  pod 'FirebaseMessaging',    '10.28.0'
  pod 'FirebaseRemoteConfig', '10.28.0'
  pod 'FlowStacks',           '0.3.6'
  pod 'GoogleMaps',           '7.4.0'
  pod 'ProgressHUD',          '14.1.0'
  pod 'SnapKit',              '5.0.1'
  pod 'SwiftLint',            '0.55.1'
  pod 'AlertToast',           '1.3.9'

  # Documentation: https://community.backbase.com/documentation/Retail-Apps-USA/2023-02-LTS/overview
  pod 'RetailUSApp',          '7.5.3' # 2023-02-LTS

  # Backbase depedencies
  pod 'RetailPaymentJourney', '5.4.1'
  pod 'RetailRemoteDepositImageCaptureAction', '4.2.0'
  pod 'UserProfileJourney', '5.2.0'
  # lock the version in order to avoid binary breaking change introduced by Jumio in version 4.9.x
  pod 'IDVerificationJourney', '6.0.2'

  pod 'WafMobileSdk', :path => "Development\ Files/Frameworks/WafMobileSdk"

  target 'westerra_dev'
  target 'westerra_uat'
  target 'westerra'
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Our frameworks are built with library evolution support enabled,
      # and they are linked against dependencies with the same setting.
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['DEVELOPMENT_TEAM'] = 'E5LZKA66G2'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
    # no longer needed and can be removed
    # update_vg_parallax_pod()
  end

  # Fix swiftinterface files for Xcode
  frameworks = [
    'RetailAccountsAndTransactionsJourney',
    'RetailAccountsAndTransactionsJourneyAccountsUseCase',
    'RetailAccountsAndTransactionsJourneyTransactionsUseCase',
    'RetailCardsManagementJourney',
    'RetailCardsManagementJourneyCardsUseCase',
    'BusinessWorkspacesJourney',
    'BusinessWorkspacesJourneyWorkspacesUseCase2',
    'BusinessJourneyCommon',
    'BusinessDesign'
  ]
  frameworks.each do |framework|
    directory = File.join(installer_representation.config.project_pods_root, framework)
    Dir[ File.join(directory, '**', '*') ].reject { |p| File.directory? p
      if File.extname(p) == '.swiftinterface'
        puts("Updating " + p)
        system("sed -i '' 's/import _Concurrency//g' #{p}")
        system("sed -i '' 's/@_Concurrency\.MainActor(unsafe) //g' #{p}")
      end
    }
  end
end

# Temporary fix for this dependency to import correctly one of it's subdependencies
def update_vg_parallax_pod
  filename = [Dir.pwd, "Pods", "VGParallaxHeader", "VGParallaxHeader", "UIScrollView+VGParallaxHeader.m"].join("/")
  File.chmod(0700, filename)
  text = File.read(filename)
  new_contents = text.gsub("#import <PureLayout.h>", "#import <PureLayout/PureLayout.h>")
  File.open(filename, "w") {|file| file.puts new_contents }
end
