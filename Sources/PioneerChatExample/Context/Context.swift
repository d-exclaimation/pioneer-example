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
    var auth: String?
    var userLoader: DataLoader<UUID, User>
    var roomLoader: DataLoader<UUID, Room>
    var messageLoader: DataLoader<Message.ParentID, [Message]>
}

extension Context {
    @Sendable
    static func http(req: Request, res: Response) async throws -> Context {
        .init(
            db: req.db,
            auth: req.headers[.authorization].compactMap { Context.getAuthToken(from: $0) }.first,
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }

    @Sendable
    static func ws(req: Request, params: ConnectionParams, gql: GraphQLRequest) async throws -> Context {
        guard case .string(let token) = params?["Authorization"] else {
            return .init(
                db: req.db,
                userLoader: Context.userLoader(req: req),
                roomLoader: Context.roomLoader(req: req),
                messageLoader: Context.messageLoader(req: req)
            )
        }
        return .init(
            db: req.db,
            auth: Context.getAuthToken(from: token),
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }
}