//
//  resolver.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 18:34.
//

import Pioneer

/// Main structure that contains all resolver function
/// and can be used to perform dependecies injection
struct Resolver {
    let pubsub = AsyncPubSub()
}