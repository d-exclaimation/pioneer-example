//
//  Room.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:44.
//

import Fluent
import Foundation

final class Room: Model {
    static let schema: String = "rooms"

    @ID(key: .id)
    var id: UUID?

    init() {}

    init(id: UUID? = nil) {
        self.id = id
    }
}