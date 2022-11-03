//
//  main.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 18:29.
//

import Vapor
import Pioneer
import Fluent
import FluentPostgresDriver
import GraphQLDepthLimit

// Make a new Vapor application
let app = try Application(.detect())

// Connect to a PostgreSQL
// - Make sure you either change this value or match your database to this
app.databases.use(
    .postgres(hostname: "localhost", username: "postgres", password: "postgres", database: "pioneer-chat"),
    as: .psql
)

// Automatically handle migrations
app.migrations.add(CreateUser(), CreateRoom(), CreateMessage())
try app.autoMigrate().wait()

// Make a new Pioneer server with the appropriate configuration
let server = try Pioneer(
    schema: schema(), 
    resolver: .init(), 
    httpStrategy: .csrfPrevention, 
    websocketProtocol: .graphqlWs, 
    introspection: true, 
    playground: .sandbox,
    validationRules: .computed({ gql in 
        [depthLimit(gql.ast, max: 10)]
    })
)

// Apply Pioneer server handler to the Application
app.middleware.use(
    server.vaporMiddleware(
        at: [.anything, "graphql"],
        context: Context.http(req:res:),
        websocketContext: Context.ws(req:params:gql:),
        websocketGuard: { req, params in
            guard case .string(_) = params?["Authorization"] else {
                throw Abort(.unauthorized)
            }
        }
    ),
    at: .beginning
)

defer {
    app.shutdown()
}

try app.run()