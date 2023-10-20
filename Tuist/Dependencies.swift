import ProjectDescription

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/aws-amplify/amplify-swift", requirement: .upToNextMajor(from: "2.15.1"))
], targetSettings: [
    "Amplify": [
        "GENERATE_MASTER_OBJECT_FILE": "YES"
    ],
    "AmplifyBigInteger": [
        "OTHER_SWIFT_FLAGS": "-Xcc -Wno-error=non-modular-include-in-framework-module",
        "HEADER_SEARCH_PATHS": .array([
            "$(inherited)",
            "$(SRCROOT)/AmplifyPlugins/Auth/Sources/libtommath/include"
        ])
    ]
])

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
