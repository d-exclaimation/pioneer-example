//
//  MessageResolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 10:05.
//

import Fluent
import Graphiti
import NIO
import Pioneer

extension Resolver {
    struct WriteArgs: Decodable {
        var to: ID
        var content: String
    }

    func write(ctx: Context, args: WriteArgs) async throws -> WriteResult {
        guard let user = await signedUser(ctx: ctx), let uid = user.id else {
            return Unauthorized(operation: "write")
        }
        guard let rid = args.to.uuid else {
            return InvalidRoom(roomId: args.to)
        }
        let message = Message(content: args.content, userId: uid, roomId: rid)
        try await message.create(on: ctx.db)
        return NewMessage(message: message)
    }
}

extension Message {
    func author(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> User {
        try await ctx.userLoader.load(key: user.id ?? .init(), on: ev)
    }

    func room(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> Room {
        try await ctx.roomLoader.load(key: room.id ?? .init(), on: ev)
    }
}