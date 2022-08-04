//
//  User.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 19:40.
//

import Foundation
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema: String = "users"

    @ID(key: "id")
    var id: UUID?

    @Field(key: "name")
    var name: String

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}