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
        do {
            return try await User.query(on: ctx.db).all()
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }
}