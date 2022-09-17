// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PioneerChatExample",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/GraphQLSwift/Graphiti", from: "1.1.1"),
        .package(url: "https://github.com/GraphQLSwift/DataLoader", from: "2.2.0"),
        .package(url: "https://github.com/vapor/vapor", from: "4.64.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0"),
        .package(path: "../../libs/pioneer")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "PioneerChatExample",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Graphiti", package: "Graphiti"),
                .product(name: "DataLoader", package: "DataLoader"),
                .product(name: "Pioneer", package: "pioneer")
            ]),
        .testTarget(
            name: "PioneerChatExampleTests",
            dependencies: ["PioneerChatExample"]),
    ]
)
