//
//  Room.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:44.
//

import Fluent
import Foundation

/// A certain Room / channel of messages
final class Room: Model, Codable, @unchecked Sendable {
    static let schema: String = "rooms"

    /// Room unique identifier
    @ID(key: .id)
    var id: UUID?

    init() {}

    init(id: UUID? = nil) {
        self.id = id
    }
}