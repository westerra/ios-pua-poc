import Foundation
/**
 CodePush release react action

 - parameters:
   - apiToken: API Token for App Center Access
   - ownerName: Name of the owner of the application on App Center
   - appName: Name of the application on App Center
   - deployment: Deployment name for releasing to
   - targetVersion: Target binary version for example 1.0.1
   - mandatory: mandatory update or not
   - description: Release description for CodePush
   - dryRun: Print the command that would be run, and don't run it
   - disabled: Specifies whether this release should be immediately downloadable
   - noDuplicateReleaseError: Specifies whether to return an error if the main bundle is identical to the latest codepush release
   - bundleName: Specifies the name of the bundle file
   - outputDir: Specifies path to where the bundle and sourcemap should be written
   - sourcemapOutput: Specifies path to write sourcemap to
   - development: Specifies whether to generate a dev build
   - useLocalAppcenterCli: When true, the appcenter cli installed in the project directory is used
   - plistFile: Path to the Info.plist
   - xcodeProjectFile: Path to the .pbxproj file
   - privateKeyPath: Path to private key that will be used for signing bundles
   - useHermes: Enable hermes and bypass automatic checks
   - extraBundlerOptions: Options that get passed to the react-native bundler
*/
public func appcenterCodepushReleaseReact(apiToken: String,
                                          ownerName: String,
                                          appName: String,
                                          deployment: String = "Staging",
                                          targetVersion: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          mandatory: OptionalConfigValue<Bool> = .fastlaneDefault(true),
                                          description: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          dryRun: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                          disabled: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                          noDuplicateReleaseError: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                          bundleName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          outputDir: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          sourcemapOutput: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          development: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                          useLocalAppcenterCli: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                          plistFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          xcodeProjectFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          privateKeyPath: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                          useHermes: OptionalConfigValue<Bool?> = .fastlaneDefault(nil),
                                          extraBundlerOptions: OptionalConfigValue<[String]?> = .fastlaneDefault(nil)) {
let apiTokenArg = RubyCommand.Argument(name: "api_token", value: apiToken, type: nil)
let ownerNameArg = RubyCommand.Argument(name: "owner_name", value: ownerName, type: nil)
let appNameArg = RubyCommand.Argument(name: "app_name", value: appName, type: nil)
let deploymentArg = RubyCommand.Argument(name: "deployment", value: deployment, type: nil)
let targetVersionArg = targetVersion.asRubyArgument(name: "target_version", type: nil)
let mandatoryArg = mandatory.asRubyArgument(name: "mandatory", type: nil)
let descriptionArg = description.asRubyArgument(name: "description", type: nil)
let dryRunArg = dryRun.asRubyArgument(name: "dry_run", type: nil)
let disabledArg = disabled.asRubyArgument(name: "disabled", type: nil)
let noDuplicateReleaseErrorArg = noDuplicateReleaseError.asRubyArgument(name: "no_duplicate_release_error", type: nil)
let bundleNameArg = bundleName.asRubyArgument(name: "bundle_name", type: nil)
let outputDirArg = outputDir.asRubyArgument(name: "output_dir", type: nil)
let sourcemapOutputArg = sourcemapOutput.asRubyArgument(name: "sourcemap_output", type: nil)
let developmentArg = development.asRubyArgument(name: "development", type: nil)
let useLocalAppcenterCliArg = useLocalAppcenterCli.asRubyArgument(name: "use_local_appcenter_cli", type: nil)
let plistFileArg = plistFile.asRubyArgument(name: "plist_file", type: nil)
let xcodeProjectFileArg = xcodeProjectFile.asRubyArgument(name: "xcode_project_file", type: nil)
let privateKeyPathArg = privateKeyPath.asRubyArgument(name: "private_key_path", type: nil)
let useHermesArg = useHermes.asRubyArgument(name: "use_hermes", type: nil)
let extraBundlerOptionsArg = extraBundlerOptions.asRubyArgument(name: "extra_bundler_options", type: nil)
let array: [RubyCommand.Argument?] = [apiTokenArg,
ownerNameArg,
appNameArg,
deploymentArg,
targetVersionArg,
mandatoryArg,
descriptionArg,
dryRunArg,
disabledArg,
noDuplicateReleaseErrorArg,
bundleNameArg,
outputDirArg,
sourcemapOutputArg,
developmentArg,
useLocalAppcenterCliArg,
plistFileArg,
xcodeProjectFileArg,
privateKeyPathArg,
useHermesArg,
extraBundlerOptionsArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "appcenter_codepush_release_react", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Fetches a list of devices from App Center to distribute an iOS app to

 - parameters:
   - apiToken: API Token for App Center
   - ownerName: Owner name
   - appName: App name
   - devicesFile: File to save devices to
   - destinations: Comma separated list of distribution group names. Default is 'Collaborators', use '*' for all distribution groups

 - returns: CSV file formatted for multi-device registration with Apple

 List is a tab-delimited CSV file containing every device from specified distribution groups for an app in App Center. Especially useful when combined with register_devices and match to automatically register and provision devices with Apple. By default, only the Collaborators group will be included, use `destination: '*'` to match all groups.
*/
public func appcenterFetchDevices(apiToken: String,
                                  ownerName: String,
                                  appName: String,
                                  devicesFile: String = "devices.txt",
                                  destinations: String = "Collaborators") {
let apiTokenArg = RubyCommand.Argument(name: "api_token", value: apiToken, type: nil)
let ownerNameArg = RubyCommand.Argument(name: "owner_name", value: ownerName, type: nil)
let appNameArg = RubyCommand.Argument(name: "app_name", value: appName, type: nil)
let devicesFileArg = RubyCommand.Argument(name: "devices_file", value: devicesFile, type: nil)
let destinationsArg = RubyCommand.Argument(name: "destinations", value: destinations, type: nil)
let array: [RubyCommand.Argument?] = [apiTokenArg,
ownerNameArg,
appNameArg,
devicesFileArg,
destinationsArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "appcenter_fetch_devices", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Fetches the latest version number of an app or the last build number of a version from App Center

 - parameters:
   - apiToken: API Token for App Center Access
   - ownerName: Name of the owner of the application on App Center
   - appName: Name of the application on App Center
   - version: The version to get the latest release for
*/
public func appcenterFetchVersionNumber(apiToken: String,
                                        ownerName: String,
                                        appName: String,
                                        version: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let apiTokenArg = RubyCommand.Argument(name: "api_token", value: apiToken, type: nil)
let ownerNameArg = RubyCommand.Argument(name: "owner_name", value: ownerName, type: nil)
let appNameArg = RubyCommand.Argument(name: "app_name", value: appName, type: nil)
let versionArg = version.asRubyArgument(name: "version", type: nil)
let array: [RubyCommand.Argument?] = [apiTokenArg,
ownerNameArg,
appNameArg,
versionArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "appcenter_fetch_version_number", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Distribute new release to App Center

 - parameters:
   - apiToken: API Token for App Center
   - ownerType: Owner type, either 'user' or 'organization'
   - ownerName: Owner name as found in the App's URL in App Center
   - appName: App name as found in the App's URL in App Center. If there is no app with such name, you will be prompted to create one
   - appDisplayName: App display name to use when creating a new app
   - appOs: App OS can be Android, iOS, macOS, Windows, Custom. Used for new app creation, if app 'app_name' was not found
   - appPlatform: App Platform. Used for new app creation, if app 'app_name' was not found
   - apk: **DEPRECATED!** Build release path for android build
   - aab: **DEPRECATED!** Build release path for android app bundle build
   - ipa: **DEPRECATED!** Build release path for iOS builds
   - file: File path to the release build to publish
   - uploadBuildOnly: Flag to upload only the build to App Center. Skips uploading symbols or mapping
   - dsym: Path to your symbols file. For iOS provide path to app.dSYM.zip
   - uploadDsymOnly: Flag to upload only the dSYM file to App Center
   - mapping: Path to your Android mapping.txt
   - uploadMappingOnly: Flag to upload only the mapping.txt file to App Center
   - group: **DEPRECATED!** Comma separated list of Distribution Group names
   - destinations: Comma separated list of destination names, use '*' for all distribution groups if destination type is 'group'. Both distribution groups and stores are supported. All names are required to be of the same destination type
   - destinationIds: Comma separated list of destination ids, use '00000000-0000-0000-0000-000000000000' for distributing to the Collaborators group. Only distribution groups are supported
   - destinationType: Destination type of distribution destination. 'group' and 'store' are supported
   - mandatoryUpdate: Require users to update to this release. Ignored if destination type is 'store'
   - notifyTesters: Send email notification about release. Ignored if destination type is 'store'
   - releaseNotes: Release notes
   - shouldClip: Clip release notes if its length is more then 5000, true by default
   - releaseNotesLink: Additional release notes link
   - buildNumber: The build number, required for macOS .pkg and .dmg builds, as well as Android ProGuard `mapping.txt` when using `upload_mapping_only`
   - version: The build version, required for .pkg, .dmg, .zip and .msi builds, as well as Android ProGuard `mapping.txt` when using `upload_mapping_only`
   - timeout: Request timeout in seconds applied to individual HTTP requests. Some commands use multiple HTTP requests, large file uploads are also split in multiple HTTP requests
   - dsaSignature: DSA signature of the macOS or Windows release for Sparkle update feed
   - edSignature: EdDSA signature of the macOS or Windows release for Sparkle update feed
   - strict: Strict mode, set to 'true' to fail early in case a potential error was detected

 Symbols will also be uploaded automatically if a `app.dSYM.zip` file is found next to `app.ipa`. In case it is located in a different place you can specify the path explicitly in `:dsym` parameter.
*/
public func appcenterUpload(apiToken: String,
                            ownerType: String = "user",
                            ownerName: String,
                            appName: String,
                            appDisplayName: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            appOs: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            appPlatform: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            apk: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            aab: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            ipa: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            file: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            uploadBuildOnly: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                            dsym: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            uploadDsymOnly: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                            mapping: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            uploadMappingOnly: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                            group: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            destinations: String = "Collaborators",
                            destinationIds: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            destinationType: String = "group",
                            mandatoryUpdate: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                            notifyTesters: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                            releaseNotes: String = "No changelog given",
                            shouldClip: OptionalConfigValue<Bool> = .fastlaneDefault(true),
                            releaseNotesLink: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            buildNumber: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            version: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            timeout: OptionalConfigValue<Int?> = .fastlaneDefault(nil),
                            dsaSignature: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            edSignature: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                            strict: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let apiTokenArg = RubyCommand.Argument(name: "api_token", value: apiToken, type: nil)
let ownerTypeArg = RubyCommand.Argument(name: "owner_type", value: ownerType, type: nil)
let ownerNameArg = RubyCommand.Argument(name: "owner_name", value: ownerName, type: nil)
let appNameArg = RubyCommand.Argument(name: "app_name", value: appName, type: nil)
let appDisplayNameArg = appDisplayName.asRubyArgument(name: "app_display_name", type: nil)
let appOsArg = appOs.asRubyArgument(name: "app_os", type: nil)
let appPlatformArg = appPlatform.asRubyArgument(name: "app_platform", type: nil)
let apkArg = apk.asRubyArgument(name: "apk", type: nil)
let aabArg = aab.asRubyArgument(name: "aab", type: nil)
let ipaArg = ipa.asRubyArgument(name: "ipa", type: nil)
let fileArg = file.asRubyArgument(name: "file", type: nil)
let uploadBuildOnlyArg = uploadBuildOnly.asRubyArgument(name: "upload_build_only", type: nil)
let dsymArg = dsym.asRubyArgument(name: "dsym", type: nil)
let uploadDsymOnlyArg = uploadDsymOnly.asRubyArgument(name: "upload_dsym_only", type: nil)
let mappingArg = mapping.asRubyArgument(name: "mapping", type: nil)
let uploadMappingOnlyArg = uploadMappingOnly.asRubyArgument(name: "upload_mapping_only", type: nil)
let groupArg = group.asRubyArgument(name: "group", type: nil)
let destinationsArg = RubyCommand.Argument(name: "destinations", value: destinations, type: nil)
let destinationIdsArg = destinationIds.asRubyArgument(name: "destination_ids", type: nil)
let destinationTypeArg = RubyCommand.Argument(name: "destination_type", value: destinationType, type: nil)
let mandatoryUpdateArg = mandatoryUpdate.asRubyArgument(name: "mandatory_update", type: nil)
let notifyTestersArg = notifyTesters.asRubyArgument(name: "notify_testers", type: nil)
let releaseNotesArg = RubyCommand.Argument(name: "release_notes", value: releaseNotes, type: nil)
let shouldClipArg = shouldClip.asRubyArgument(name: "should_clip", type: nil)
let releaseNotesLinkArg = releaseNotesLink.asRubyArgument(name: "release_notes_link", type: nil)
let buildNumberArg = buildNumber.asRubyArgument(name: "build_number", type: nil)
let versionArg = version.asRubyArgument(name: "version", type: nil)
let timeoutArg = timeout.asRubyArgument(name: "timeout", type: nil)
let dsaSignatureArg = dsaSignature.asRubyArgument(name: "dsa_signature", type: nil)
let edSignatureArg = edSignature.asRubyArgument(name: "ed_signature", type: nil)
let strictArg = strict.asRubyArgument(name: "strict", type: nil)
let array: [RubyCommand.Argument?] = [apiTokenArg,
ownerTypeArg,
ownerNameArg,
appNameArg,
appDisplayNameArg,
appOsArg,
appPlatformArg,
apkArg,
aabArg,
ipaArg,
fileArg,
uploadBuildOnlyArg,
dsymArg,
uploadDsymOnlyArg,
mappingArg,
uploadMappingOnlyArg,
groupArg,
destinationsArg,
destinationIdsArg,
destinationTypeArg,
mandatoryUpdateArg,
notifyTestersArg,
releaseNotesArg,
shouldClipArg,
releaseNotesLinkArg,
buildNumberArg,
versionArg,
timeoutArg,
dsaSignatureArg,
edSignatureArg,
strictArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "appcenter_upload", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Release your beta builds with Firebase App Distribution

 - parameters:
   - ipaPath: Path to your IPA file. Optional if you use the _gym_ or _xcodebuild_ action
   - googleserviceInfoPlistPath: Path to your GoogleService-Info.plist file, relative to the archived product path
   - apkPath: Path to your APK file
   - androidArtifactPath: Path to your APK or AAB file
   - androidArtifactType: Android artifact type. Set to 'APK' or 'AAB'. Defaults to 'APK' if not set
   - app: Your app's Firebase App ID. You can find the App ID in the Firebase console, on the General Settings page
   - firebaseCliPath: **DEPRECATED!** This plugin no longer uses the Firebase CLI - Absolute path of the Firebase CLI command
   - debug: Print verbose debug output
   - uploadTimeout: Amount of seconds before the upload will  timeout, if not completed
   - groups: Group aliases used for distribution, separated by commas
   - groupsFile: Path to file containing group aliases used for distribution, separated by commas
   - testers: Email addresses of testers, separated by commas
   - testersFile: Path to file containing email addresses of testers, separated by commas
   - releaseNotes: Release notes for this build
   - releaseNotesFile: Path to file containing release notes for this build
   - testDevices: List of devices to run automated tests on, in the format 'model=<model-id>,version=<os-version-id>,locale=<locale>,orientation=<orientation>;model=<model-id>,...'. Run 'gcloud firebase test android|ios models list' to see available devices. Note: This feature is in beta
   - testDevicesFile: Path to file containing a list of devices to run automated tests on, in the format 'model=<model-id>,version=<os-version-id>,locale=<locale>,orientation=<orientation>;model=<model-id>,...'. Run 'gcloud firebase test android|ios models list' to see available devices. Note: This feature is in beta
   - testUsername: Username for automatic login
   - testPassword: Password for automatic login. If using a real password consider using test_password_file or setting FIREBASEAPPDISTRO_TEST_PASSWORD to avoid exposing sensitive info
   - testPasswordFile: Path to file containing password for automatic login
   - testUsernameResource: Resource name for the username field for automatic login
   - testPasswordResource: Resource name for the password field for automatic login
   - testNonBlocking: Run automated tests without waiting for them to finish. Visit the Firebase console for the test results
   - firebaseCliToken: Auth token generated using the Firebase CLI's login:ci command
   - serviceCredentialsFile: Path to Google service account json file
   - serviceCredentialsJsonData: Google service account json file content

 Release your beta builds with Firebase App Distribution
*/
public func firebaseAppDistribution(ipaPath: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    googleserviceInfoPlistPath: String = "GoogleService-Info.plist",
                                    apkPath: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    androidArtifactPath: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    androidArtifactType: String = "APK",
                                    app: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    firebaseCliPath: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    debug: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                    uploadTimeout: Int = 300,
                                    groups: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    groupsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testers: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testersFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    releaseNotes: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    releaseNotesFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testDevices: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testDevicesFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testUsername: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testPassword: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testPasswordFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testUsernameResource: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testPasswordResource: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    testNonBlocking: OptionalConfigValue<Bool> = .fastlaneDefault(false),
                                    firebaseCliToken: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    serviceCredentialsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                    serviceCredentialsJsonData: OptionalConfigValue<String?> = .fastlaneDefault(nil)) {
let ipaPathArg = ipaPath.asRubyArgument(name: "ipa_path", type: nil)
let googleserviceInfoPlistPathArg = RubyCommand.Argument(name: "googleservice_info_plist_path", value: googleserviceInfoPlistPath, type: nil)
let apkPathArg = apkPath.asRubyArgument(name: "apk_path", type: nil)
let androidArtifactPathArg = androidArtifactPath.asRubyArgument(name: "android_artifact_path", type: nil)
let androidArtifactTypeArg = RubyCommand.Argument(name: "android_artifact_type", value: androidArtifactType, type: nil)
let appArg = app.asRubyArgument(name: "app", type: nil)
let firebaseCliPathArg = firebaseCliPath.asRubyArgument(name: "firebase_cli_path", type: nil)
let debugArg = debug.asRubyArgument(name: "debug", type: nil)
let uploadTimeoutArg = RubyCommand.Argument(name: "upload_timeout", value: uploadTimeout, type: nil)
let groupsArg = groups.asRubyArgument(name: "groups", type: nil)
let groupsFileArg = groupsFile.asRubyArgument(name: "groups_file", type: nil)
let testersArg = testers.asRubyArgument(name: "testers", type: nil)
let testersFileArg = testersFile.asRubyArgument(name: "testers_file", type: nil)
let releaseNotesArg = releaseNotes.asRubyArgument(name: "release_notes", type: nil)
let releaseNotesFileArg = releaseNotesFile.asRubyArgument(name: "release_notes_file", type: nil)
let testDevicesArg = testDevices.asRubyArgument(name: "test_devices", type: nil)
let testDevicesFileArg = testDevicesFile.asRubyArgument(name: "test_devices_file", type: nil)
let testUsernameArg = testUsername.asRubyArgument(name: "test_username", type: nil)
let testPasswordArg = testPassword.asRubyArgument(name: "test_password", type: nil)
let testPasswordFileArg = testPasswordFile.asRubyArgument(name: "test_password_file", type: nil)
let testUsernameResourceArg = testUsernameResource.asRubyArgument(name: "test_username_resource", type: nil)
let testPasswordResourceArg = testPasswordResource.asRubyArgument(name: "test_password_resource", type: nil)
let testNonBlockingArg = testNonBlocking.asRubyArgument(name: "test_non_blocking", type: nil)
let firebaseCliTokenArg = firebaseCliToken.asRubyArgument(name: "firebase_cli_token", type: nil)
let serviceCredentialsFileArg = serviceCredentialsFile.asRubyArgument(name: "service_credentials_file", type: nil)
let serviceCredentialsJsonDataArg = serviceCredentialsJsonData.asRubyArgument(name: "service_credentials_json_data", type: nil)
let array: [RubyCommand.Argument?] = [ipaPathArg,
googleserviceInfoPlistPathArg,
apkPathArg,
androidArtifactPathArg,
androidArtifactTypeArg,
appArg,
firebaseCliPathArg,
debugArg,
uploadTimeoutArg,
groupsArg,
groupsFileArg,
testersArg,
testersFileArg,
releaseNotesArg,
releaseNotesFileArg,
testDevicesArg,
testDevicesFileArg,
testUsernameArg,
testPasswordArg,
testPasswordFileArg,
testUsernameResourceArg,
testPasswordResourceArg,
testNonBlockingArg,
firebaseCliTokenArg,
serviceCredentialsFileArg,
serviceCredentialsJsonDataArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "firebase_app_distribution", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Create testers in bulk from a comma-separated list or a file

 - parameters:
   - projectNumber: Your Firebase project number. You can find the project number in the Firebase console, on the General Settings page
   - emails: Comma separated list of tester emails to be created. A maximum of 1000 testers can be created at a time
   - file: Path to a file containing a comma separated list of tester emails to be created. A maximum of 1000 testers can be deleted at a time
   - groupAlias: Alias of the group to add the specified testers to. The group must already exist. If not specified, testers will not be added to a group
   - serviceCredentialsFile: Path to Google service credentials file
   - serviceCredentialsJsonData: Google service account json file content
   - firebaseCliToken: Auth token generated using the Firebase CLI's login:ci command
   - debug: Print verbose debug output

 Create testers in bulk from a comma-separated list or a file
*/
public func firebaseAppDistributionAddTesters(projectNumber: Int,
                                              emails: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              file: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              groupAlias: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              serviceCredentialsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              serviceCredentialsJsonData: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              firebaseCliToken: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                              debug: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let projectNumberArg = RubyCommand.Argument(name: "project_number", value: projectNumber, type: nil)
let emailsArg = emails.asRubyArgument(name: "emails", type: nil)
let fileArg = file.asRubyArgument(name: "file", type: nil)
let groupAliasArg = groupAlias.asRubyArgument(name: "group_alias", type: nil)
let serviceCredentialsFileArg = serviceCredentialsFile.asRubyArgument(name: "service_credentials_file", type: nil)
let serviceCredentialsJsonDataArg = serviceCredentialsJsonData.asRubyArgument(name: "service_credentials_json_data", type: nil)
let firebaseCliTokenArg = firebaseCliToken.asRubyArgument(name: "firebase_cli_token", type: nil)
let debugArg = debug.asRubyArgument(name: "debug", type: nil)
let array: [RubyCommand.Argument?] = [projectNumberArg,
emailsArg,
fileArg,
groupAliasArg,
serviceCredentialsFileArg,
serviceCredentialsJsonDataArg,
firebaseCliTokenArg,
debugArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "firebase_app_distribution_add_testers", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Create a tester group

 - parameters:
   - projectNumber: Your Firebase project number. You can find the project number in the Firebase console, on the General Settings page
   - alias: Alias of the group to be created
   - displayName: Display name for the group to be created
   - serviceCredentialsFile: Path to Google service credentials file
   - serviceCredentialsJsonData: Google service account json file content
   - firebaseCliToken: Auth token generated using the Firebase CLI's login:ci command
   - debug: Print verbose debug output

 Create a tester group
*/
public func firebaseAppDistributionCreateGroup(projectNumber: Int,
                                               alias: String,
                                               displayName: String,
                                               serviceCredentialsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                               serviceCredentialsJsonData: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                               firebaseCliToken: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                               debug: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let projectNumberArg = RubyCommand.Argument(name: "project_number", value: projectNumber, type: nil)
let aliasArg = RubyCommand.Argument(name: "alias", value: alias, type: nil)
let displayNameArg = RubyCommand.Argument(name: "display_name", value: displayName, type: nil)
let serviceCredentialsFileArg = serviceCredentialsFile.asRubyArgument(name: "service_credentials_file", type: nil)
let serviceCredentialsJsonDataArg = serviceCredentialsJsonData.asRubyArgument(name: "service_credentials_json_data", type: nil)
let firebaseCliTokenArg = firebaseCliToken.asRubyArgument(name: "firebase_cli_token", type: nil)
let debugArg = debug.asRubyArgument(name: "debug", type: nil)
let array: [RubyCommand.Argument?] = [projectNumberArg,
aliasArg,
displayNameArg,
serviceCredentialsFileArg,
serviceCredentialsJsonDataArg,
firebaseCliTokenArg,
debugArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "firebase_app_distribution_create_group", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Delete a tester group

 - parameters:
   - projectNumber: Your Firebase project number. You can find the project number in the Firebase console, on the General Settings page
   - alias: Alias of the group to be deleted
   - serviceCredentialsFile: Path to Google service credentials file
   - serviceCredentialsJsonData: Google service account json file content
   - firebaseCliToken: Auth token generated using the Firebase CLI's login:ci command
   - debug: Print verbose debug output

 Delete a tester group
*/
public func firebaseAppDistributionDeleteGroup(projectNumber: Int,
                                               alias: String,
                                               serviceCredentialsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                               serviceCredentialsJsonData: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                               firebaseCliToken: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                               debug: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let projectNumberArg = RubyCommand.Argument(name: "project_number", value: projectNumber, type: nil)
let aliasArg = RubyCommand.Argument(name: "alias", value: alias, type: nil)
let serviceCredentialsFileArg = serviceCredentialsFile.asRubyArgument(name: "service_credentials_file", type: nil)
let serviceCredentialsJsonDataArg = serviceCredentialsJsonData.asRubyArgument(name: "service_credentials_json_data", type: nil)
let firebaseCliTokenArg = firebaseCliToken.asRubyArgument(name: "firebase_cli_token", type: nil)
let debugArg = debug.asRubyArgument(name: "debug", type: nil)
let array: [RubyCommand.Argument?] = [projectNumberArg,
aliasArg,
serviceCredentialsFileArg,
serviceCredentialsJsonDataArg,
firebaseCliTokenArg,
debugArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "firebase_app_distribution_delete_group", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Fetches the latest release in Firebase App Distribution

 - parameters:
   - app: Your app's Firebase App ID. You can find the App ID in the Firebase console, on the General Settings page
   - firebaseCliToken: Auth token generated using Firebase CLI's login:ci command
   - serviceCredentialsFile: Path to Google service account json
   - serviceCredentialsJsonData: Google service account json file content
   - debug: Print verbose debug output

 - returns: Hash representation of the lastest release created in Firebase App Distribution (see https://firebase.google.com/docs/reference/app-distribution/rest/v1/projects.apps.releases#resource:-release). Example: {:name=>"projects/123456789/apps/1:1234567890:ios:0a1b2c3d4e5f67890/releases/0a1b2c3d4", :releaseNotes=>{:text=>"Here are some release notes!"}, :displayVersion=>"1.2.3", :buildVersion=>"10", :binaryDownloadUri=>"<URI>", :firebaseConsoleUri=>"<URI>", :testingUri=>"<URI>", :createTime=>"2021-10-06T15:01:23Z"}

 Fetches information about the most recently created release in App Distribution, including the version and release notes. Returns nil if no releases are found.
*/
@discardableResult public func firebaseAppDistributionGetLatestRelease(app: String,
                                                                       firebaseCliToken: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                                       serviceCredentialsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                                       serviceCredentialsJsonData: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                                       debug: OptionalConfigValue<Bool> = .fastlaneDefault(false)) -> [String : Any] {
let appArg = RubyCommand.Argument(name: "app", value: app, type: nil)
let firebaseCliTokenArg = firebaseCliToken.asRubyArgument(name: "firebase_cli_token", type: nil)
let serviceCredentialsFileArg = serviceCredentialsFile.asRubyArgument(name: "service_credentials_file", type: nil)
let serviceCredentialsJsonDataArg = serviceCredentialsJsonData.asRubyArgument(name: "service_credentials_json_data", type: nil)
let debugArg = debug.asRubyArgument(name: "debug", type: nil)
let array: [RubyCommand.Argument?] = [appArg,
firebaseCliTokenArg,
serviceCredentialsFileArg,
serviceCredentialsJsonDataArg,
debugArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "firebase_app_distribution_get_latest_release", className: nil, args: args)
  return parseDictionary(fromString: runner.executeCommand(command))
}

/**
 Download the UDIDs of your Firebase App Distribution testers

 - parameters:
   - projectNumber: Your Firebase project number. You can find the project number in the Firebase console, on the General Settings page
   - app: **DEPRECATED!** Use project_number (FIREBASEAPPDISTRO_PROJECT_NUMBER) instead - Your app's Firebase App ID. You can find the App ID in the Firebase console, on the General Settings page
   - outputFile: The path to the file where the tester UDIDs will be written
   - firebaseCliToken: Auth token generated using the Firebase CLI's login:ci command
   - serviceCredentialsFile: Path to Google service account json
   - serviceCredentialsJsonData: Google service account json file content
   - debug: Print verbose debug output

 Export your testers' device identifiers in a CSV file, so you can add them your provisioning profile. This file can be imported into your Apple developer account using the Register Multiple Devices option. See the [App Distribution docs](https://firebase.google.com/docs/app-distribution/ios/distribute-console#register-tester-devices) for more info.
*/
public func firebaseAppDistributionGetUdids(projectNumber: OptionalConfigValue<Int?> = .fastlaneDefault(nil),
                                            app: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            outputFile: String,
                                            firebaseCliToken: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            serviceCredentialsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            serviceCredentialsJsonData: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                            debug: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let projectNumberArg = projectNumber.asRubyArgument(name: "project_number", type: nil)
let appArg = app.asRubyArgument(name: "app", type: nil)
let outputFileArg = RubyCommand.Argument(name: "output_file", value: outputFile, type: nil)
let firebaseCliTokenArg = firebaseCliToken.asRubyArgument(name: "firebase_cli_token", type: nil)
let serviceCredentialsFileArg = serviceCredentialsFile.asRubyArgument(name: "service_credentials_file", type: nil)
let serviceCredentialsJsonDataArg = serviceCredentialsJsonData.asRubyArgument(name: "service_credentials_json_data", type: nil)
let debugArg = debug.asRubyArgument(name: "debug", type: nil)
let array: [RubyCommand.Argument?] = [projectNumberArg,
appArg,
outputFileArg,
firebaseCliTokenArg,
serviceCredentialsFileArg,
serviceCredentialsJsonDataArg,
debugArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "firebase_app_distribution_get_udids", className: nil, args: args)
  _ = runner.executeCommand(command)
}

/**
 Delete testers in bulk from a comma-separated list or a file

 - parameters:
   - projectNumber: Your Firebase project number. You can find the project number in the Firebase console, on the General Settings page
   - emails: Comma separated list of tester emails to be deleted (or removed from a group if a group alias is specified). A maximum of 1000 testers can be deleted/removed at a time
   - file: Path to a file containing a comma separated list of tester emails to be deleted (or removed from a group if a group alias is specified). A maximum of 1000 testers can be deleted/removed at a time
   - groupAlias: Alias of the group to remove the specified testers from. Testers will not be deleted from the project
   - serviceCredentialsFile: Path to Google service credentials file
   - serviceCredentialsJsonData: Google service account json file content
   - firebaseCliToken: Auth token generated using the Firebase CLI's login:ci command
   - debug: Print verbose debug output

 Delete testers in bulk from a comma-separated list or a file
*/
public func firebaseAppDistributionRemoveTesters(projectNumber: Int,
                                                 emails: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                 file: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                 groupAlias: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                 serviceCredentialsFile: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                 serviceCredentialsJsonData: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                 firebaseCliToken: OptionalConfigValue<String?> = .fastlaneDefault(nil),
                                                 debug: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let projectNumberArg = RubyCommand.Argument(name: "project_number", value: projectNumber, type: nil)
let emailsArg = emails.asRubyArgument(name: "emails", type: nil)
let fileArg = file.asRubyArgument(name: "file", type: nil)
let groupAliasArg = groupAlias.asRubyArgument(name: "group_alias", type: nil)
let serviceCredentialsFileArg = serviceCredentialsFile.asRubyArgument(name: "service_credentials_file", type: nil)
let serviceCredentialsJsonDataArg = serviceCredentialsJsonData.asRubyArgument(name: "service_credentials_json_data", type: nil)
let firebaseCliTokenArg = firebaseCliToken.asRubyArgument(name: "firebase_cli_token", type: nil)
let debugArg = debug.asRubyArgument(name: "debug", type: nil)
let array: [RubyCommand.Argument?] = [projectNumberArg,
emailsArg,
fileArg,
groupAliasArg,
serviceCredentialsFileArg,
serviceCredentialsJsonDataArg,
firebaseCliTokenArg,
debugArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "firebase_app_distribution_remove_testers", className: nil, args: args)
  _ = runner.executeCommand(command)
}
