// For more information about the Appfile, see:
//     https://docs.fastlane.tools/advanced/#appfile

var gitURL: String { "git@github.com:westerra/mobile-ios-certs.git" }

let westerraWorkspace: OptionalConfigValue<String?> = "westerra.xcworkspace"

let bundleIdDEV = "com.westerracu.mobile.dev"
let bundleIdUAT = "com.westerracu.mobile.uat"
let bundleIdPROD = "com.westerracu.bbmobile"

let firebaseAppIdDEV = "1:561032792118:ios:201f9efdf0fc6861ba7097"
let firebaseAppIdUAT = "1:561032792118:ios:a402ad9d79e21b31ba7097"
let firebaseAppIdPROD = "1:561032792118:ios:37d95dc602eefcb0ba7097"

let firebaseDeveloperGroup: OptionalConfigValue<String?> = "developers"
let firebaseTesterGroup: OptionalConfigValue<String?> = "westerra-testers"

var appleID: String { return "[[APPLE_ID]]" } // Your Apple email address

var itcTeam: String? { "6670852" } // App Store Connect Team ID
var teamID: String { "E5LZKA66G2" } // Apple Developer Portal Team ID

let buildDestination: OptionalConfigValue<String?> = "generic/platform=iOS"
let buildArgs: OptionalConfigValue<String?> = "-allowProvisioningUpdates -skipPackagePluginValidation"

let temporaryKeychainName = "fastlane_tmp_keychain"
let fastlaneCredentialsFile: OptionalConfigValue<String?> = "fastlane-credentials.json"
