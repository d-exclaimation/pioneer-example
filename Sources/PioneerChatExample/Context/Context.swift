//
//  context.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 18:34.
//

import Vapor
import Fluent
import Pioneer

struct Context {
    var db: Database
}

extension Context {
    @Sendable
    static func http(req: Request, res: Response) async throws -> Context {
        .init(db: req.db)
    }

    @Sendable
    static func ws(req: Request, params: ConnectionParams, gql: GraphQLRequest) async throws -> Context {
        .init(db: req.db)
    }
}