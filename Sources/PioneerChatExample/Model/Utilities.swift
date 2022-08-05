//
// .Utilities.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 15:35.
//

protocol AuthResult: Codable {}

struct LoggedUser: Codable, AuthResult {
    var user: User
    var token: String
}

struct InvalidName: Codable, AuthResult {
    var name: String
}

struct Unauthorized: Codable {
    var operation: String
}