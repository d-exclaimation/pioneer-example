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

/// The context object that will be computed on each request and pass into all resolvers
struct Context {
    /// The fluent database 
    var db: Database

    /// The user logged in for the request if any
    var auth: User?

    /// The data loader for loading users by their id
    var userLoader: DataLoader<UUID, User>

    /// The data loader for loading rooms by their id
    var roomLoader: DataLoader<UUID, Room>

    /// The data loader for loading messages by their parent id
    var messageLoader: DataLoader<Message.ParentID, [Message]>
}

extension Context {
    /// Get the context from the HTTP context builder
    /// - Parameters:
    ///   - req: The HTTP request for the GraphQL operation
    ///   - res: The HTTP response that is going to be sent back
    /// - Returns: A full context with all its properties
    @Sendable static func http(req: Request, res: Response) async throws -> Context {
        // Get first the auth token from the Authorization header if any
        let authToken = req.headers[.authorization].compactMap(Context.authToken(from:)).first
        return await .init(
            db: req.db,
            auth: Context.signedUser(given: authToken, on: req.db),
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }

    /// Get the context from the WebSocket context builder
    /// - Parameters:
    ///   - req: The HTTP request for upgrading to WebSocket
    ///   - params: The connection parameters given when initializing connection
    ///   - gql: The GraphQL operation itself
    /// - Returns: A full context with all its properties, if authenticated
    @Sendable static func ws(req: Request, params: ConnectionParams, gql: GraphQLRequest) async throws -> Context {
        // Get the Authorization header equivalent in the connection parameter, otherwise unauthorized
        guard case .string(let token) = params?["Authorization"] else {
            throw Abort(.unauthorized)
        }

        // Get the signed in user, otherwise unauthorized
        let authToken = Context.authToken(from: token)
        guard case .some(let user) = await Context.signedUser(given: authToken, on: req.db) else {
            throw Abort(.unauthorized)
        }

        return .init(
            db: req.db,
            auth: user,
            userLoader: Context.userLoader(req: req),
            roomLoader: Context.roomLoader(req: req),
            messageLoader: Context.messageLoader(req: req)
        )
    }
}