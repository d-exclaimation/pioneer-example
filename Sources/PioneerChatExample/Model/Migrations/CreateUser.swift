//
//  CreateUser.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:45.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("userss").delete()
    }
}