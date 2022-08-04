//
//  schema.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 18:34.
//

import Graphiti


func schema() throws -> Schema<Resolver, Context> {
    try .init {
        Type(Room.self) {
            Field("id", at: \.gid)
        }

        Type(User.self) {
            Field("id", at: \.gid)
            Field("name", at: \.name)
        }

        Type(Message.self) {
            Field("id", at: \.gid)
            Field("content", at: \.content)
            Field("createdAt", at: \.createAtIso)
        }

        Query {
            
        }
    }
}