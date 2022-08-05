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
    struct Token: JWTPayload, Equatable {
        enum CodingKeys: String, CodingKey {
            case subject = "sub"
            case expiration = "exp"
            case uid = "uid"
        }

        var subject: SubjectClaim
        var expiration: ExpirationClaim
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

    var token: Token? {
        guard let id = id else {
            return nil
        }
        return .init(id)
    }
}