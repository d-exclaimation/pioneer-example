//
//  Context+Auth.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 14:06.
//

import JWTKit
import Fluent

// Extensions to the context to get authentication information
extension Context {
    /// The auth JWT token from the Authorization header
    /// - Parameter header: The raw header value
    /// - Returns: A JWT token if the token exist
    static func authToken(from header: String) -> String? {
        guard header.contains("Bearer") else {
            return nil
        }
        return header.split(separator: " ").last?.description
    }

    /// Get the signed user given the JWT token
    /// - Parameters:
    ///   - auth: The JWT token to retrive the User id 
    ///   - db: The database to get the user if any
    /// - Returns: The user object if exist
    static func signedUser(given auth: String?, on db: Database) async -> User? {
        guard let auth = auth, let token = try? Auth.signers.verify(auth, as: User.Token.self) else {
            return nil
        }
        return try? await User.find(token.uid, on: db)
    }
}