//
//  UserToken.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 13:48.
//

import Foundation
import GraphQL
import JWTKit

extension User {
    /// Token structure for a particular user to be encodable as JWT payload
    struct Token: JWTPayload, Equatable {
        enum CodingKeys: String, CodingKey {
            case subject = "sub"
            case expiration = "exp"
            case uid = "uid"
        }

        /// The JWT subject claim
        var subject: SubjectClaim

        /// The time where the JWT token generated would no longer be usable
        var expiration: ExpirationClaim

        /// The user id to be stored
        var uid: UUID

        func verify(using signer: JWTSigner) throws {
            try expiration.verifyNotExpired()
        }

        init(_ uid: UUID) {
            let next2Week = Calendar.current.date(byAdding: .weekOfYear, value: 2, to: .init())

            self.subject = "chat-user"
            self.expiration = .init(value: next2Week ?? .distantFuture)
            self.uid = uid
        }
    }

    /// Create a token from the user object
    var token: Token? {
        guard let id = id else {
            return nil
        }
        return .init(id)
    }
}