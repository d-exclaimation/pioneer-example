//
//  MessageResolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 10:05.
//

import Fluent
import Graphiti
import NIO
import Pioneer
import GraphQL

// Resolver functions around Message
extension Resolver {
    /// Writing a message arguments
    struct WriteArgs: Decodable {
        /// The Room id sent the Message to
        var to: ID
        /// The content of the Message
        var content: String
    }

    /// Write a Message to a Room (must be logged in)
    func write(ctx: Context, args: WriteArgs) async throws -> WriteResult {
        // Check for user and the user id, otherwise not authorized to continue
        guard let user = ctx.auth, let uid = user.id else {
            return Unauthorized(operation: "write")
        }
        // Check if the room id is valid
        guard let rid = args.to.uuid else {
            return InvalidRoom(roomId: args.to)
        }

        // Create message and save it to the db
        let message = Message(content: args.content, userId: uid, roomId: rid)
        try await message.create(on: ctx.db)
        
        // Asynchronously publish the message to the pubsub without blokcing this function
        Task {
            await pubsub.publish(for: rid.uuidString, payload: message)
        }
        return NewMessage(message: message)
    }

    /// Listening to messages in a room argument
    struct ListenArgs: Decodable {
        /// The Room id to listen to
        var to: ID
    }

    /// Listen to all Messages sent to a Room (must be logged in)
    func listen(ctx: Context, args: ListenArgs) throws -> EventStream<Message> {
        // Get the async stream from the pubsub with the topic of the room id
        try pubsub
            .asyncStream(Message.self, for: args.to.toUUID().uuidString)
            .toEventStream()
    } 
}

// Nested resolver under the Message object
extension Message {
    /// User who wrote this Message
    func author(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> User {
        try await ctx.userLoader.load(key: user.id ?? .init(), on: ev)
    }

    // Room where this Message is sent to
    func room(ctx: Context, args: NoArguments, ev: EventLoopGroup) async throws -> Room {
        try await ctx.roomLoader.load(key: room.id ?? .init(), on: ev)
    }
}