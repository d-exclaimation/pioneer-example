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
        // MARK: - Scalar types

        ID.asScalar()

        // MARK: - Base Object types

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

        // MARK: - Utility Object types

        Type(LoggedUser.self) {
            Field("user", at: \.user, as: User.self)
                .description("The User for this logged in result")
            Field("token", at: \.token)
                .description("JWT token for this User")
        }
            .description("A result with all the information of a Logged in User")

        Type(InvalidName.self) {
            Field("name", at: \.name)
                .description("The name in question")
        }
            .description("A result given an incorrect name")
        
        Type(Unauthorized.self) {
            Field("operation", at: \.operation)
                .description("Name of operation being performed")
        }
            .description("A result given when not logged in")

        Type(NewMessage.self) {
            Field("message", at: \.message, as: Message.self)
                .description("The Message written")
        }
            .description("A result given a successful write operation")

        Type(InvalidRoom.self) {
            Field("roomId", at: \.roomId)
                .description("The ID in question")
        }
            .description("A result given when Room id is invalid")

        
        Type(NewRoom.self) {
            Field("room", at: \.room, as: Room.self)
                .description("The Room opened") 
        }
            .description("A result given a successful open operation")

        // MARK: Union types

        Union(AuthResult.self, members: InvalidName.self, LoggedUser.self)
            .description("Results from sign up and log in")

        Union(WriteResult.self, members: Unauthorized.self, InvalidRoom.self, NewMessage.self)
            .description("Results from writing a message")

        Union(OpenResult.self, members: Unauthorized.self, NewRoom.self)
            .description("Results from openning a room")

        // MARK: Root operations

        Query {
            Field("me", at: Resolver.me)
                .description("Check for the sign in status")
            
            Field("users", at: Resolver.users)
                .description("List all signed up Users")

            Field("rooms", at: Resolver.rooms)
                .description("List all available Rooms")
        }

        Mutation {
            Field("signup", at: Resolver.signup, as: AuthResult.self) {
                Argument("name", at: \.name)
                    .description("Name of the User")
            }
                .description("Sign up a new User")

            Field("login", at: Resolver.login, as: AuthResult.self) {
                Argument("name", at: \.name)
                    .description("Name of the User")
            }
                .description("Log into an exisiting User")

            Field("write", at: Resolver.write, as: WriteResult.self) {
                Argument("to", at: \.to)
                    .description("The Room id sent the Message to")
                Argument("content", at: \.content)
                    .description("The content of the Message")
            }
                .description("Write a Message to a Room (must be logged in)")

            Field("open", at: Resolver.open, as: OpenResult.self)
                .description("Open a Room (must be logged in)")
        }
    }
}