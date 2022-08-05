//
//  Resolver+JWTKit.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 13:45.
//

import JWTKit
import Fluent

extension Resolver {
    static func jwtSigners() -> JWTSigners {
        let signers = JWTSigners()
        signers.use(.hs256(key: "some-jwt-key"))
        return signers
    }

    func signedUser(ctx: Context) async -> User? {
        guard let auth = ctx.auth, let token = try? signers.verify(auth, as: User.Token.self) else {
            return nil
        }
        return try? await User.find(token.uid, on: ctx.db)
    }

    func signUser(user: User) -> String? {
        guard let token = user.token else {
            return nil
        }
        return try? signers.sign(token)
    }
}