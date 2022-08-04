//
//  RoomResolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 09:55.
//

import Fluent
import Graphiti
import NIO

extension Resolver {
    func rooms(ctx: Context, args: NoArguments) async throws -> [Room] {
        try await Room.query(on: ctx.db).all()
    }
}

extension Room {
    func messages(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> [Message] {
        try await ctx.messageLoader
            .load(key: .room(id ?? .init()), on: ev)
            .sortedByDate()
    }
}