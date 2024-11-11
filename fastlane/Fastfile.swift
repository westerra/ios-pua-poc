// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

enum BuildEnvironment {
    case dev, uat, prod
}

class Fastfile: LaneFile {

    /* CircleCI */

    func uploadDevToFirebaseLane() {
        desc("Push DEV to Firebase App Distribution")

        incrementBuildVersion(buildEnvironment: .dev)

        signBuildAndUpload(appIdentifier: bundleIdDEV, with: "westerra_dev", for: "Westerra_DEV")
    }

    func uploadUatToFirebaseLane() {
        desc("Push UAT to Firebase App Distribution")

        incrementBuildVersion(buildEnvironment: .uat)

        signBuildAndUpload(appIdentifier: bundleIdUAT, with: "westerra_uat", for: "Westerra_UAT")
    }

    func uploadProdToFirebaseLane() {
        desc("Push PROD to Firebase App Distribution")

        incrementBuildVersion(buildEnvironment: .prod)

        signBuildAndUpload(appIdentifier: bundleIdPROD, with: "westerra", for: "Westerra")
    }

    func uploadProdToTestFlightLane() {
        desc("Push PROD to TestFlight")

        incrementBuildVersion(buildEnvironment: .prod)

        signBuildAndUploadToTestFlight()
    }

    /* Build and upload from local */

    func uploadDevToFirebaseFromLocalLane() {
        desc("Push DEV from local to Firebase App Distribution")

        incrementBuildVersion(buildEnvironment: .dev)

        signBuildAndUploadLocal(appIdentifier: bundleIdDEV, with: "westerra_dev", for: "Westerra_DEV")
    }

    func uploadUatToFirebaseFromLocalLane() {
        desc("Push UAT from local to Firebase App Distribution")

        incrementBuildVersion(buildEnvironment: .uat)

        signBuildAndUploadLocal(appIdentifier: bundleIdUAT, with: "westerra_uat", for: "Westerra_UAT")
    }

    func uploadProdToFirebaseFromLocalLane() {
        desc("Push PROD from local to Firebase App Distribution")

        incrementBuildVersion(buildEnvironment: .prod)

        signBuildAndUploadLocal(appIdentifier: bundleIdPROD, with: "westerra", for: "Westerra")
    }

    func uploadProdToTestFlightFromLocalLane() {
        desc("Push PROD from local to TestFlight")

        incrementBuildVersion(buildEnvironment: .prod)

        signBuildAndUploadToTestFlightLocal()
    }
}

private extension Fastfile {

    func signBuildAndUpload(appIdentifier: String, with scheme: OptionalConfigValue<String?>, for appName: String) {
        setupCircleCi()

        syncCodeSigning(
            type: "adhoc",
            appIdentifier: [appIdentifier],
            gitUrl: gitURL,
            keychainName: temporaryKeychainName
        )

        buildApp(
            workspace: westerraWorkspace,
            scheme: scheme,
            exportMethod: .fastlaneDefault("ad-hoc"),
            destination: buildDestination,
            xcargs: buildArgs
        )

        firebaseAppDistribution(groups: appIdentifier == bundleIdDEV ? firebaseDeveloperGroup : firebaseTesterGroup)

        deleteKeychain(name: "\(temporaryKeychainName)")
    }

    func signBuildAndUploadToTestFlight() {
        setupCircleCi()

        syncCodeSigning(
            type: "adhoc",
            appIdentifier: [bundleIdPROD],
            gitUrl: gitURL,
            keychainName: temporaryKeychainName
        )

        syncCodeSigning(
            type: "appstore",
            appIdentifier: [bundleIdPROD],
            gitUrl: gitURL,
            keychainName: temporaryKeychainName
        )

        buildApp(
            workspace: westerraWorkspace,
            scheme: "westerra",
            exportMethod: .fastlaneDefault("app-store"),
            destination: buildDestination,
            xcargs: buildArgs
        )

        uploadToTestflight(apiKeyPath: fastlaneCredentialsFile)

        deleteKeychain(name: "\(temporaryKeychainName)")
    }

    /* Local Helpers */

    func signBuildAndUploadLocal(appIdentifier: String, with scheme: OptionalConfigValue<String?>, for appName: String) {
        syncCodeSigning(
            type: "adhoc",
            appIdentifier: [appIdentifier],
            gitUrl: gitURL
        )

        buildApp(
            workspace: westerraWorkspace,
            scheme: scheme,
            exportMethod: .fastlaneDefault("ad-hoc"),
            destination: buildDestination,
            xcargs: buildArgs
        )

        firebaseAppDistribution(groups: appIdentifier == bundleIdDEV ? firebaseDeveloperGroup : firebaseTesterGroup)
    }

    func signBuildAndUploadToTestFlightLocal() {
        syncCodeSigning(
            type: "adhoc",
            appIdentifier: [bundleIdPROD],
            gitUrl: gitURL,
            keychainName: temporaryKeychainName
        )

        syncCodeSigning(
            type: "appstore",
            appIdentifier: [bundleIdPROD],
            gitUrl: gitURL
        )

        buildApp(
            workspace: westerraWorkspace,
            scheme: "westerra",
            exportMethod: .fastlaneDefault("app-store"),
            destination: buildDestination,
            xcargs: buildArgs
        )

       uploadToTestflight(apiKeyPath: fastlaneCredentialsFile)
    }

    /* Helpers */

    func incrementBuildVersion(buildEnvironment: BuildEnvironment) {
        // 1. Uncomment the following line to override with local build version
        // incrementBuildNumber(buildNumber: "1199"); return;

        // 2. Use the following logic
        //    - DEV -> increment build number
        //    - UAT & PROD -> use the last DEV build number
        let latestDevRelease = firebaseAppDistributionGetLatestRelease(app: firebaseAppIdDEV)
        var devBuildVersion = Int(latestDevRelease["buildVersion"] as! String)!

        if buildEnvironment == .dev {
            devBuildVersion += 1
            incrementBuildNumber(buildNumber: "\(devBuildVersion)")
            return
        }

        if buildEnvironment == .uat || buildEnvironment == .prod {
            incrementBuildNumber(buildNumber: "\(devBuildVersion)")
            return
        }

        // 3. CIRCLE_BUILD_NUM
        incrementBuildNumber(buildNumber: "$CIRCLE_BUILD_NUM")
    }
}
