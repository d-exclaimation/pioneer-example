//
// .Utilities.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 15:35.
//

import Pioneer

/// Results from sign up and log in
protocol AuthResult: Codable {}

/// Results from writing a message
protocol WriteResult: Codable {}

/// Results from opening a room
protocol OpenResult: Codable {}

/// A result with all the information of a Logged in User
struct LoggedUser: Codable, AuthResult {
    /// The User for this logged in result
    var user: User
    
    /// JWT token for this User
    var token: String
}

/// A result given an incorrect name
struct InvalidName: Codable, AuthResult {
    /// The name in question
    var name: String
}

/// A result given when not logged in
struct Unauthorized: Codable, WriteResult, OpenResult {
    /// Name of operation being performed
    var operation: String
}

/// A result given a successful write operation
struct NewMessage: Codable, WriteResult {
    /// The Message written
    var message: Message
}

/// A result given when Room id is invalid
struct InvalidRoom: Codable, WriteResult {
    /// The ID in question
    var roomId: ID
}

/// A result given a successful open operation
struct NewRoom: Codable, OpenResult {
    /// The Room opened
    var room: Room
}