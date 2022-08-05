//
//  Auth.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:15.
//

import JWTKit

enum Auth {
    static func jwtSigners() -> JWTSigners {
        let signers = JWTSigners()
        signers.use(.hs256(key: "some-jwt-key"))
        return signers
    }

    static let signers = jwtSigners()
}