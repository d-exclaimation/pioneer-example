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
    /// The PubSub used to publish messages to subscribers
    let pubsub: PubSub = AsyncPubSub()
}