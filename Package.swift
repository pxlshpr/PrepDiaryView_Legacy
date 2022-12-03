// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrepDiaryView",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PrepDiaryView",
            targets: ["PrepDiaryView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pxlshpr/PrepDataTypes", from: "0.0.199"),
        .package(url: "https://github.com/pxlshpr/PrepViews", from: "0.0.76"),
        .package(url: "https://github.com/pxlshpr/NamePicker", from: "0.0.19"),
        .package(url: "https://github.com/pxlshpr/SwiftUICamera", from: "0.0.35"),
        .package(url: "https://github.com/pxlshpr/SwiftUISugar", from: "0.0.237"),
        .package(url: "https://github.com/pxlshpr/SwiftHaptics", from: "0.1.3"),
        .package(url: "https://github.com/pxlshpr/Timeline", from: "0.0.56"),
        
        .package(url: "https://github.com/fermoya/SwiftUIPager", from: "2.5.0"),
   ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PrepDiaryView",
            dependencies: [
                .product(name: "Camera", package: "swiftuicamera"),
                .product(name: "PrepDataTypes", package: "prepdatatypes"),
                .product(name: "PrepViews", package: "prepviews"),
                .product(name: "NamePicker", package: "namepicker"),
                .product(name: "SwiftHaptics", package: "swifthaptics"),
                .product(name: "SwiftUISugar", package: "swiftuisugar"),
                .product(name: "Timeline", package: "timeline"),

                .product(name: "SwiftUIPager", package: "swiftuipager"),
            ]),
        .testTarget(
            name: "PrepDiaryViewTests",
            dependencies: ["PrepDiaryView"]),
    ]
)
