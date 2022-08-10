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
    contextBuilder: Context.http(req:res:),
    httpStrategy: .csrfPrevention, 
    websocketContextBuilder: Context.ws(req:params:gql:),
    websocketProtocol: .graphqlWs, 
    introspection: true, 
    playground: .redirect(to: .apolloSandbox)
)

// Adding CORS to allow Cloud version of Apollo Sandbox 
app.middleware.use(CORSMiddleware(configuration: .graphqlWithApolloSandbox()))

// Apply Pioneer server handler to the Application
server.applyMiddleware(on: app)

defer {
    app.shutdown()
}

try app.run()