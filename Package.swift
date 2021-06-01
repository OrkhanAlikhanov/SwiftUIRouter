// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "SwiftUIRouter",
  platforms: [.iOS(.v14)], //, .macOS(.v11), .tvOS(.v14), .watchOS(.v7)],
  products: [
    .library(name: "SwiftUIRouter", targets: ["SwiftUIRouter"]),
  ],
  targets: [
    .target(name: "SwiftUIRouter", dependencies: []),
    .testTarget(name: "SwiftUIRouterTests", dependencies: ["SwiftUIRouter"]),
  ]
)
