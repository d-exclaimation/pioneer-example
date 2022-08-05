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
                .description("Message unique identifier")
            Field("content", at: \.content)
                .description("Message textual content")
            Field("createdAt", at: \.createAtIso)
                .description("Message creation date and time")

            Field("author", at: Message.author, as: TypeReference<User>.self)
                .description("User who wrote this Message")
            Field("room", at: Message.room, as: TypeReference<Room>.self)
                .description("Room where this Message is sent to")
        }
            .description("A Message sent to a room by a user")

        Type(Room.self) {
            Field("id", at: \.gid)
                .description("Room unique identifier")

            Field("history", at: Room.messages, as: Message.self)
                .description("Message history for this Room sent by any User")
            Field("users", at: Room.users, as: TypeReference<User>.self)
                .description("Users who have written into this Room")
        }
            .description("A certain Room / channel of messages")

        Type(User.self) {
            Field("id", at: \.gid)
                .description("User unique identifier")
            Field("name", at: \.name)
                .description("User public name")

            Field("messages", at: User.messages, as: Message.self)
                .description("Message written by this User sent to any Room")
        }
            .description("A User who can write down messages")

        Query {
            Field("me", at: Resolver.me)
                .description("Check for the sign in status")
            
            Field("users", at: Resolver.users)
                .description("List all signed up Users")

            Field("rooms", at: Resolver.rooms)
                .description("List all available Rooms")
        }
    }
}