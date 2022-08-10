//
//  User.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:40.
//

import Foundation
import Fluent

/// A User who can write down messages
final class User: Model, Codable, @unchecked Sendable {
    static let schema: String = "users"

    /// User unique identifier
    @ID(key: "id")
    var id: UUID?

    /// User public name
    @Field(key: "name")
    var name: String

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}