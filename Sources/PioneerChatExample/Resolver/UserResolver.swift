//
//  UserResolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:34.
//

import Vapor
import Graphiti
import GraphQL
import Fluent
import Foundation

extension Resolver {
    /// List all signed up Users
    func users(ctx: Context, args: NoArguments) async throws -> [User] {
        try await User.query(on: ctx.db).all()
    }

    /// Check for the sign in status
    func me(ctx: Context, args: NoArguments) async throws -> User? {
        return ctx.auth
    }

    /// Argument for asking for a user name
    struct NameArgs: Decodable {
        /// Name of the User
        var name: String
    }

    /// Sign up a new User
    func signup(ctx: Context, args: NameArgs) async throws -> AuthResult {
        // Create the user
        let user = User(name: args.name)
        try await user.create(on: ctx.db)

        // Create the user token to generate the JWT token
        guard let token = user.token else {
            return InvalidName(name: args.name)
        }
        return try LoggedUser(user: user, token: Auth.signers.sign(token))
    }

    /// Argument for asking any login information
    struct LoginArgs: Decodable {
        /// Login information
        var info: LoginInfo
    }

    /// Log into an exisiting User
    func login(ctx: Context, args: LoginArgs) async throws -> AuthResult {
        // Find the user in question
        let user: User?

        if let name = args.info.name {
            user = try await User.query(on: ctx.db).filter(\.$name == name).first()
        } else {
            user = try await User.find(args.info.id?.uuid, on: ctx.db)
        }
        
        // Try to create the user token and the JWT token
        guard let user = user, let token = user.token else {
            return InvalidName(name: args.info.name ?? args.info.id?.string ?? "No info")
        }
        return try LoggedUser(user: user, token: Auth.signers.sign(token))
    }
}

extension User {
    /// Message written by this User sent to any Room
    func messages(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> [Message] {
        try await ctx.messageLoader.load(key: .user(id ?? .init()), on: ev)
    }
}