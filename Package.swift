// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SyntaxHighlightingOptics",
  products: [
    .library(
      name: "SyntaxHighlightingOptics",
      targets: ["SyntaxHighlightingOptics"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "0.4.0")
  ],
  targets: [
    .target(
      name: "SyntaxHighlightingOptics",
      dependencies: []),
    .testTarget(
      name: "SyntaxHighlightingOpticsTests",
      dependencies: [
        "SyntaxHighlightingOptics",
        .product(name: "CasePaths", package: "swift-case-paths"),
      ]),
  ]
)
