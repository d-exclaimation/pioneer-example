//
//  context.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 18:34.
//

import Vapor
import Fluent
import Pioneer
import DataLoader

struct Context {
    var db: Database
    var auth: User?
    var userLoader: DataLoader<UUID, User>
    var roomLoader: DataLoader<UUID, Room>
    var messageLoader: DataLoader<Message.ParentID, [Message]>
}

extension Context {
    @Sendable
    static func http(req: Request, res: Response) async throws -> Context {
        let authToken = req.headers[.authorization].compactMap { Context.getAuthToken(from: $0) }.first
        return await .init(
            db: req.db,
            auth: Context.signedUser(given: authToken, on: req.db),
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }

    @Sendable
    static func ws(req: Request, params: ConnectionParams, gql: GraphQLRequest) async throws -> Context {
        guard case .string(let token) = params?["Authorization"] else {
            throw Abort(.unauthorized)
        }
        let authToken = Context.getAuthToken(from: token)
        guard case .some(let user) = await Context.signedUser(given: authToken, on: req.db) else {
            throw Abort(.unauthorized)
        }

        try print(String(data: JSONEncoder().encode(gql.variables), encoding: .utf8) ?? "")
        
        return .init(
            db: req.db,
            auth: user,
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }
}