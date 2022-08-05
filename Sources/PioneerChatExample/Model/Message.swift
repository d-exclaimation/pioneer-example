//
//  Message.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:56.
//

import Foundation
import Fluent

final class Message: Model, DatedModel, Codable, @unchecked Sendable {
    static let schema: String = "messages"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "content")
    var content: String

    @Timestamp(key: "created_at", on: .create, format: .iso8601)
    var createdAt: Date?

    @Parent(key: "user_id")
    var user: User

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