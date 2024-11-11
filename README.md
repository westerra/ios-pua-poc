## Westerra iOS setup instructions

1. Configure `cocoapods-art` credentials to access Backbase repo

```bash
export COCOAPODS_ART_CREDENTIALS="admin:password"
```

2. Add Backbase repositories

```bash
pod repo-art add backbase-pods3 https://repo.backbase.com/api/pods/ios3
pod repo-art add backbase-pods-business https://repo.backbase.com/api/pods/ios-business
pod repo-art add backbase-pods-design-system https://repo.backbase.com/api/pods/design-ios
pod repo-art add backbase-pods-engagement-channels https://repo.backbase.com/api/pods/ios-engagement-channels
pod repo-art add backbase-pods-flow https://repo.backbase.com/api/pods/ios-flow-production
pod repo-art add backbase-pods-identity https://repo.backbase.com/api/pods/ios-identity
pod repo-art add backbase-pods-mitek-misnap https://repo.backbase.com/api/pods/ios-mitek-misnap
pod repo-art add backbase-pods-notifications https://repo.backbase.com/api/pods/ios-mobile-notifications
pod repo-art add backbase-pods-retail3 https://repo.backbase.com/api/pods/ios-retail3
```


3. Install Backbase dependencies

```bash
pod repo-art update backbase-pods3
pod repo-art update backbase-pods-business
pod repo-art update backbase-pods-design-system
pod repo-art update backbase-pods-engagement-channels
pod repo-art update backbase-pods-flow
pod repo-art update backbase-pods-identity
pod repo-art update backbase-pods-mitek-misnap
pod repo-art update backbase-pods-notifications
pod repo-art update backbase-pods-retail3
pod install
```

4. Open `westerra.xcworkspace` in Xcode

## CircleCI

- Available macOS environments https://circleci.com/docs/using-macos/

## Certificates and Profiles
- Use `fastlane match` to install or update certificates and provisioning profiles
- Documentation: https://docs.fastlane.tools/actions/match/

```bash
fastlane match development

fastlane match adhoc

fastlane match appstore
```

## Adding new test devices
- Follow the Firebase App Distribution instructions to add the device
- Ensure the new device is included in DEV adn ADHOC provisioning profiles in Apple Developer Account
- Run the following commands to update the provisioning profiles:
    - `fastlane match development`
    - `fastlane match adhoc`

## Uploading to Firebase App Distribution from local
- Install fastlane by running `bundle install` in Terminal
- Configure local environment variable `export GOOGLE_APPLICATION_CREDENTIALS=~/.ssh/firebase-app-distribution-private-key.json` in `~/.zshrc`
- Run one of the following commands
- ***Note***: Westerra VPN sometimes interferes with downloading `mobile-certs` repository

```bash
fastlane uploadDevToFirebaseFromLocalLane

fastlane uploadUatToFirebaseFromLocalLane

fastlane uploadProdToFirebaseFromLocalLane

fastlane uploadProdToTestFlightFromLocalLane
```

## Release Process
- Checkout latest `develop` branch
- Create a release branch `git checkout -b release/2.2407.0`
- Open the project in Xcode by double-clicking `westerra.xcworkspace`
- Update version to `2.2407.0` in all three targets: `westerra`, `westerra_dev`, and `westerra_uat`
- Commit the updated version
- Create a PR from `release/2.2407.0` to `develop` branch
- Go through the CircleCI pipeline and build DEV, UAT, and PROD
- Do a full app regression testing with QA and new features/bug fixes
- Once approved, build TestFlight version from CircleCI
- App Store Review Submission:
    - Go to App Store Connect -> Apps -> WesterraCU
    - Create a new release version (i.e. 2.2407.0)
    - Copy `What's New in This Version` section from the live version to the new version
    - Add the QA approved build version under `Builds` section
    - Click Save and then submit for App Store Review
- App Store Release:
    - Once approved, the app can be released from App Store Connect portal
- **Troubleshooting**: if GitHub clone of `mobile-ios-certs` fails, ensure Westerra VPN is not active

## iOS Backbase SDK Update

### Set up kickstart project ###
1. Download the latest LTS version of Retail Banking US iOS App starting project from [repo](https://repo.backbase.com/ui/native/backbase-releases/com/backbase/apps/retail-banking-us-ios/).
2. Prepare the source code for the first run
    a. Use the init script to generate `westerra` Xcode project. Follow directions in the README file.
    a. Add and install Backbase repositories.
    b. Configure `config.js` by specifying the values for the `serverUrl`, `version` and `identity`.
4. Ensure API services are upgraded to the same LTS version
5. Ensure out-of-the-box LTS version is up and running
6. At this point, we can start moving custom journeys and other customizations to the new LTS versions of each platform.

### Code migration ###

1. Migrate custom dependencies to Podfile and install via `pod install`.
2. Ensure custom journeys, screens, and assets moved over to the kickstarter project.
3. Build the project to ensure no compilation errors.
4. Run the migrated project against DEV environment. Make sure API is updated to the same LTS version.
5. Update any deprecated SDK calls if there are any.
6. Do a full regression test on the updated LTS version of the app.
7. Run the mobile automation tests and ensure all tests pass.

### Useful Resources ###
- [Backbase Release Notes](https://backbase.io/developers/documentation/release-notes/)
- [JFrog Repo](https://repo.backbase.com/ui/packages)
- [Dependencies](https://backbase.io/developers/documentation/retail-banking-usa/2024.03-LTS/dependency-component-versions/ios/)
- [Deprecations](https://backbase.io/developers/documentation/release-notes/deprecations/deprecations-mobile-ios/)
- [Mobile DevKit](https://backbase.io/developers/mobile-devkit/)
- [Mobile DevKit Release notes](https://backbase.io/developers/documentation/release-notes/mobile-devkit/overview/)
- [Design System](https://designsystem.backbase.com/get-started/ios-)
- [Golden Sample App](https://github.com/Backbase/golden-sample-app-ios)
- Experience Backbase Products: [documentation](https://backbase.io/ebp-sandbox/launcher?experience=retail) and [credentials](https://backbase.io/ebp-sandbox/user-credentials?experience=retail)