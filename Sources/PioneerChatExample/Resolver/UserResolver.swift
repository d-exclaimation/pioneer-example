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

    func me(ctx: Context, args: NoArguments) async throws -> User? {
        return await signedUser(ctx: ctx)
    }

    struct NameArgs: Decodable {
        var name: String
    }

    func signup(ctx: Context, args: NameArgs) async throws -> AuthResult {
        let user = User(name: args.name)
        try await user.create(on: ctx.db)
        guard let token = user.token else {
            return InvalidName(name: args.name)
        }
        return try LoggedUser(user: user, token: signers.sign(token))
    }

    func login(ctx: Context, args: NameArgs) async throws -> AuthResult {
        let user = try await User.query(on: ctx.db).filter(\.$name == args.name).first()
        guard let user = user, let token = user.token else {
            return InvalidName(name: args.name)
        }
        return try LoggedUser(user: user, token: signers.sign(token))
    }
}

extension User {
    func messages(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> [Message] {
        try await ctx.messageLoader.load(key: .user(id ?? .init()), on: ev)
    }
}