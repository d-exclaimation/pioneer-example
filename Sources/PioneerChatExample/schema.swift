//
//  schema.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 18:34.
//

import Pioneer
import Graphiti


func schema() throws -> Schema<Resolver, Context> {
    try .init {
        ID.asScalar()

        Type(Message.self) {
            Field("id", at: \.gid)
            Field("content", at: \.content)
            Field("createdAt", at: \.createAtIso)

            Field("author", at: Message.author, as: TypeReference<User>.self)
            Field("room", at: Message.room, as: TypeReference<Room>.self)
        }

        Type(Room.self) {
            Field("id", at: \.gid)
            
            Field("history", at: Room.messages, as: Message.self)
            Field("users", at: Room.users, as: TypeReference<User>.self)
        }

        Type(User.self) {
            Field("id", at: \.gid)
            Field("name", at: \.name)

            Field("messages", at: User.messages, as: Message.self)
        }

        Query {
            Field("users", at: Resolver.users)
            Field("rooms", at: Resolver.rooms)
        }
    }
}