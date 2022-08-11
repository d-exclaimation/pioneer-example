//
//  Auth.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:15.
//

import JWTKit

/// Global / static JWT signers
enum Auth {
    /// Create a new JWT Signers with the proper algorithm and key
    fileprivate static func jwtSigners() -> JWTSigners {
        let signers = JWTSigners()
        signers.use(.hs256(key: "some-jwt-key"))
        return signers
    }

    /// Global signers
    static let signers = jwtSigners()
}