//
//  RoomResolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 09:55.
//

import Fluent
import Graphiti
import NIO

// Resolver functions around Room
extension Resolver {
    /// List all available Rooms
    func rooms(ctx: Context, args: NoArguments) async throws -> [Room] {
        try await Room.query(on: ctx.db).all()
    }

    /// Open a Room (must be logged in)
    func open(ctx: Context, args: NoArguments) async throws -> OpenResult {
        // Check for user authentication, otherwise unauthorized
        guard case .some(_) = ctx.auth else {
            return Unauthorized(operation: "open")
        }

        // Make a new room and save it to the db
        let room = Room()
        try await room.create(on: ctx.db)
        return NewRoom(room: room)
    }
}

extension Room {
    /// Message history for this Room sent by any User
    func messages(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> [Message] {
        try await ctx.messageLoader
            .load(key: .room(id ?? .init()), on: ev)
            .sortedByDate()
    }

    /// Users who have written into this Room
    func users(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> [User] {
        // Get all the messages from the dataloader and all unique user ids
        let messages = try await messages(ctx: ctx, args: args, ev: ev)
        let uniqueUserIds = Set(messages.map(\.user.id)).map { $0 ?? .init() }

        // Load all unique users from the message
        return try await ctx.userLoader
            .loadMany(keys: uniqueUserIds, on: ev)
    }
}