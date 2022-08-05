//
//  Context+Auth.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 14:06.
//

import JWTKit

extension Context {
    static func getAuthToken(from header: String) -> String? {
        guard header.contains("Bearer") else {
            return nil
        }
        return header.split(separator: " ").last?.description
    }
}