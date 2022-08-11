//
//  DataLoaders.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:42.
//

import Foundation
import Vapor
import DataLoader
import Fluent

extension Context {
    /// DataLoader for users by their id
    /// - Parameter req: The request to get the event loop and database
    /// - Returns: A DataLoader for user
    static func userLoader(req: Request) -> DataLoader<UUID, User> {
        return .init(on: req) { keys in
            // Get all users which id is in the keys
            let users = try? await User.query(on: req.db).filter(\.$id ~~ keys).all()

            // Map the key by the resulting users by their ids
            return keys.map { key in
                guard let user = users?.first(where: { $0.id == key }) else {
                    return .failure(Abort(.badRequest))
                }
                return .success(user)
            }
        }
    }

    /// DataLoader for rooms by their id
    /// - Parameter req: The request to get the event loop and database
    /// - Returns: A DataLoader for room
    static func roomLoader(req: Request) -> DataLoader<UUID, Room> {
        return .init(on: req) { keys in
            // Get all rooms which id is in the keys
            let rooms = try? await Room.query(on: req.db).filter(\.$id ~~ keys).all()

            // Map the key by the resulting rooms by their ids
            return keys.map { key in
                guard let room = rooms?.first(where: { $0.id == key }) else {
                    return .failure(Abort(.badRequest))
                }
                return .success(room)
            } 
        }
    }
    
    /// DataLoader for messages by their parent ids
    /// - Parameter req: The request to get the event loop and database
    /// - Returns: A DataLoader for messages
    static func messageLoader(req: Request) -> DataLoader<Message.ParentID, [Message]> {
        return .init(on: req) { parents in 
            // Get the user ids
            let userIds = parents.compactMap { parent -> UUID? in 
                guard case .user(let uuid) = parent else {
                    return nil
                }
                return uuid
            }
            // Get the room ids
            let roomIds = parents.compactMap { parent -> UUID? in 
                guard case .room(let uuid) = parent else {
                    return nil
                }
                return uuid
            }

            // Find all messages that either have the user foreign key or the room foreign key
            let messages = try? await Message
                .query(on: req.db)
                .group(.or) {
                    $0.filter(\.user.$id ~~ userIds).filter(\.room.$id ~~ roomIds)
                }
                .all()
            
            // If there is no message return failure for all keys
            guard let messages = messages else {
                return parents.map { _ in .failure(Abort(.badRequest)) }
            }


            // Otherwise, filter the messages by the appropriate keys
            return parents.map { parent in 
                switch parent {
                case .room(let roomId):
                    return .success(messages.filter { $0.room.id == roomId } )
                case .user(let userId):
                    return .success(messages.filter { $0.user.id == userId })
                }
            }
        }
    }
}

extension Message {
    /// The possible parent id / foreign key for a message
    enum ParentID: Hashable {
        /// Room ID / Foreign key
        case room(UUID)
        /// User ID / Foreign key
        case user(UUID)
    }
}