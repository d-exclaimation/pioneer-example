// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PioneerChatExample",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/GraphQLSwift/Graphiti", from: "1.2.1"),
        .package(url: "https://github.com/GraphQLSwift/DataLoader", from: "2.2.0"),
        .package(url: "https://github.com/vapor/vapor", from: "4.64.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/d-exclaimation/graphql-depth-limit", from: "0.1.0"),
        .package(url: "https://github.com/d-exclaimation/pioneer", from: "1.0.0-beta")
    ],
    targets: [
        .executableTarget(
            name: "PioneerChatExample",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Graphiti", package: "Graphiti"),
                .product(name: "DataLoader", package: "DataLoader"),
                .product(name: "GraphQLDepthLimit", package: "graphql-depth-limit"),
                .product(name: "Pioneer", package: "pioneer")
            ]),
        .testTarget(
            name: "PioneerChatExampleTests",
            dependencies: ["PioneerChatExample"]),
    ]
)
