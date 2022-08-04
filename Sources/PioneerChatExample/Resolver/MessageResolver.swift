//
//  MessageResolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 10:05.
//

import Fluent
import Graphiti
import NIO

extension Resolver {

}

extension Message {
    func author(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> User {
        try await ctx.userLoader.load(key: user.id ?? .init(), on: ev)
    }

    func room(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> Room {
        try await ctx.roomLoader.load(key: room.id ?? .init(), on: ev)
    }
}