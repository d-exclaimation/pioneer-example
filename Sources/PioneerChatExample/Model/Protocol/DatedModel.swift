//
//  DatedModel.swift
//  PioneerChatExample
//
//  Created by d-exclaimation on 20:23.
//

import Foundation
import protocol Fluent.Model

/// Any model with a createdAt field
protocol DatedModel: Model {
    /// Created at date and time
    var createdAt: Date? { get }
}

extension DatedModel {
    /// An ISO formatted datetime for the created at field
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
    /// Returns the elements of the sequence, sorted using the given their createdAt field
    /// - Returns: A sorted array of the sequence’s elements
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