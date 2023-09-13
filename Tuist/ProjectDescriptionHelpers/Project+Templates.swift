import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(
            name: name,
            platform: platform,
            product: .framework,
            bundleId: "io.tuist.\(name)",
            infoPlist: .default,
            sources: ["Targets/\(name)/Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "Amplify"),
                .external(name: "AWSCognitoAuthPlugin"),
                .external(name: "AWSAPIPlugin"),
            ],
            settings: .settings(base: [
                "OTHER_SWIFT_FLAGS": "-Xcc -Wno-error=non-modular-include-in-framework-module",
                "HEADER_SEARCH_PATHS": .array([
                    "$(inherited)",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-auth/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-cal/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-io/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-common/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-sdkutils/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-http/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-compression/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/config",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/aws-crt-swift/aws-common-runtime/aws-c-event-stream/include",
                    "$(SRCROOT)/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/amplify-swift/AmplifyPlugins/Auth/Sources/libtommath/include"
                ])
            ])
        )
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}
