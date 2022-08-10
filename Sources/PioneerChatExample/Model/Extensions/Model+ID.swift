//
//  Model+ID.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:16.
//

import Foundation
import struct Pioneer.ID
import protocol Fluent.Model

extension Model where IDValue == UUID, Self: Identifiable {
    /// GraphQL ID from a Model's UUID
    var gid: Pioneer.ID {
        id?.toID() ?? .uuid()
    }
}