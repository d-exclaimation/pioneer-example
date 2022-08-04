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
    static func userLoader(req: Request) -> DataLoader<UUID, User> {
        return .init(on: req) { keys in
            let users = try? await User.query(on: req.db).filter(\.$id ~~ keys).all()
            return keys.map { key in
                guard let user = users?.first(where: { $0.id == key }) else {
                    return .failure(Abort(.badRequest))
                }
                return .success(user)
            }
        }
    }

    static func roomLoader(req: Request) -> DataLoader<UUID, Room> {
        return .init(on: req) { keys in
            let rooms = try? await Room.query(on: req.db).filter(\.$id ~~ keys).all()
            return keys.map { key in
                guard let room = rooms?.first(where: { $0.id == key }) else {
                    return .failure(Abort(.badRequest))
                }
                return .success(room)
            } 
        }
    }
    
    static func messageLoader(req: Request) -> DataLoader<Message.ParentID, [Message]> {
        return .init(on: req) { parents in 
            let userIds = parents.compactMap { parent -> UUID? in 
                guard case .user(let uuid) = parent else {
                    return nil
                }
                return uuid
            }
            let roomIds = parents.compactMap { parent -> UUID? in 
                guard case .room(let uuid) = parent else {
                    return nil
                }
                return uuid
            }
            let messages = try? await Message
                .query(on: req.db)
                .group(.or) {
                    $0.filter(\.user.$id ~~ userIds).filter(\.room.$id ~~ roomIds)
                }
                .all()
            
            guard let messages = messages else {
                return parents.map { _ in .failure(Abort(.badRequest)) }
            }

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
    enum ParentID: Hashable {
        case room(UUID)
        case user(UUID)
    }
}