// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "CaseSupport",
  platforms: [.macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "CaseSupport",
      targets: ["CaseSupport"]
    ),
    .executable(
      name: "CaseSupportClient",
      targets: ["CaseSupportClient"]
    )
  ],
  dependencies: [
    .package(path: "../MacroTester"),
    .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
//    .package(
//      url: "https://github.com/realm/SwiftLint",
//      from: "0.53.0"
//    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // Macro implementation that performs the source transformation of a macro.
    .macro(
      name: "CaseSupportMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),

    // Library that exposes a macro as part of its API, which is used in client programs.
    .target(
      name: "CaseSupport",
      dependencies: ["CaseSupportMacros"]
    ),

    // A client of the library, which is able to use the macro in its own code.
    .executableTarget(
      name: "CaseSupportClient",
      dependencies: ["CaseSupport"]
    )

    //    https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes
    //    Swift Packages
    //    Known Issues
    //    Swift Macros may fail to build when target destination is a platform other than macOS. (110541100)
    //    Workaround: Build by choosing the macOS destination, or by removing the .testTarget from package.swift.

//    // A test target used to develop the macro implementation.
//    .testTarget(
//      name: "CaseSupportTests",
//      dependencies: [
//        "CaseSupportMacros",
//        .product(name: "MacroTester", package: "MacroTester"),
//        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
//      ]
//    )
  ]
)
