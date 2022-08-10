//
//  Message.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:56.
//

import Foundation
import Fluent

/// A Message sent to a room by a user
final class Message: Model, DatedModel, Codable, @unchecked Sendable {
    static let schema: String = "messages"

    /// Message unique identifier
    @ID(key: .id)
    var id: UUID?

    /// Message textual content
    @Field(key: "content")
    var content: String

    /// Message creation date and time
    @Timestamp(key: "created_at", on: .create, format: .iso8601)
    var createdAt: Date?

    /// User who wrote this Message
    @Parent(key: "user_id")
    var user: User

    /// Room where this Message is sent to
    @Parent(key: "room_id")
    var room: Room

    init() {}

    init(id: UUID? = nil, content: String, userId: User.IDValue, roomId: Room.IDValue) {
        self.id = id
        self.content = content
        self.createdAt = nil
        self.$user.id = userId
        self.$room.id = roomId
    }
}