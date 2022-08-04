//
//  DatedModel.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:23.
//

import Foundation
import protocol Fluent.Model

protocol DatedModel: Model {
    var createdAt: Date? { get }
}

extension DatedModel {
    var createAtIso: String {
        guard let createdAt = self.createdAt else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: createdAt)
    }
}

extension Array where Element: DatedModel {
    func sortedByDate() -> [Element] {
        sorted {
            switch ($0.createdAt, $1.createdAt) {
            case (.some(let lhs), .some(let rhs)):
                return lhs <= rhs
            case (.some(_), .none):
                return true
            case (.none, .some(_)):
                return false
            default:
                return true
            }
        }
    }
}