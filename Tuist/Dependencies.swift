import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/aws-amplify/amplify-swift", requirement: .upToNextMajor(from: "2.15.1")),
    ],
    platforms: [.iOS]
)
