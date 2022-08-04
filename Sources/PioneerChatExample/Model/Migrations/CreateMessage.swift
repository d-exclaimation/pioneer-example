//
//  CreateMessage.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:08.
//

import Fluent

struct CreateMessage: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("messages")
            .id()
            .field("content", .string, .required)
            .field("created_at", .string)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("room_id", .uuid, .required, .references("rooms", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("userss").delete()
    }
}