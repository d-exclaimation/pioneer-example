//
//  CreateUser.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:45.
//

import Fluent

/// The migration to create the user table and also drop it
struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}