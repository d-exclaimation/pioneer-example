//
//  UserResolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:34.
//

import Vapor
import Graphiti
import Fluent
import Foundation

extension Resolver {
    func users(ctx: Context, args: NoArguments) async throws -> [User] {
        try await User.query(on: ctx.db).all()
    }
}

extension User {
    func messages(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> [Message] {
        try await ctx.messageLoader.load(key: .user(id ?? .init()), on: ev)
    }
}