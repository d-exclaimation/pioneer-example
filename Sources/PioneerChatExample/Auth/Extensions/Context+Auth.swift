//
//  Context+Auth.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 14:06.
//

import JWTKit
import Fluent

extension Context {
    static func getAuthToken(from header: String) -> String? {
        guard header.contains("Bearer") else {
            return nil
        }
        return header.split(separator: " ").last?.description
    }

    static func signedUser(given auth: String?, on db: Database) async -> User? {
        guard let auth = auth, let token = try? Auth.signers.verify(auth, as: User.Token.self) else {
            return nil
        }
        return try? await User.find(token.uid, on: db)
    }
}