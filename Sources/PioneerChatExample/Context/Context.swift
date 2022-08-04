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
    var userLoader: DataLoader<UUID, User>
    var roomLoader: DataLoader<UUID, Room>
    var messageLoader: DataLoader<Message.ParentID, [Message]>
}

extension Context {
    @Sendable
    static func http(req: Request, res: Response) async throws -> Context {
        .init(
            db: req.db,
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }

    @Sendable
    static func ws(req: Request, params: ConnectionParams, gql: GraphQLRequest) async throws -> Context {
        .init(
            db: req.db,
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }
}