//
// .Utilities.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 15:35.
//

import Pioneer

protocol AuthResult: Codable {}

protocol WriteResult: Codable {}

protocol OpenResult: Codable {}

struct LoggedUser: Codable, AuthResult {
    var user: User
    var token: String
}

struct InvalidName: Codable, AuthResult {
    var name: String
}

struct Unauthorized: Codable, WriteResult, OpenResult {
    var operation: String
}

struct NewMessage: Codable, WriteResult {
    var message: Message
}

struct InvalidRoom: Codable, WriteResult {
    var roomId: ID
}

struct NewRoom: Codable, OpenResult {
    var room: Room
}