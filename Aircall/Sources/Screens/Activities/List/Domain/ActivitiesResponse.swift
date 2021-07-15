//
//  ActivitiesResponse.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

typealias ActivitiesResponse = [ActivityResponse]

// MARK: - ActivitiesResponseElement
struct ActivityResponse: Codable {
    let id: Int
    let createdAt: String
    let direction: Direction
    let from: String
    let to: String?
    let via: String
    let duration: String
    let isArchived: Bool
    let callType: String

    enum Direction: String, Codable {
        case inbound
        case outbound
    }

    enum CallType: String, Codable {
        case voicemail
        case answered
    }

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case direction
        case from
        case to
        case via
        case duration
        case isArchived = "is_archived"
        case callType = "call_type"
    }
}
