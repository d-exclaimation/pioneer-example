//
//  CreateRoom.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:56.
//

import Fluent

struct CreateRoom: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("rooms")
            .id()
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("rooms").delete()
    }
}