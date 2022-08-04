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

let app = try Application(.detect())

app.databases.use(
    .postgres(hostname: "localhost", username: "postgres", password: "postgres", database: "pioneer-chat"),
    as: .psql
)

app.migrations.add(CreateUser(), CreateRoom(), CreateMessage())

try app.autoMigrate().wait()

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

app.middleware.use(CORSMiddleware(configuration: .graphqlWithApolloSandbox()))

server.applyMiddleware(on: app)

defer {
    app.shutdown()
}

try app.run()