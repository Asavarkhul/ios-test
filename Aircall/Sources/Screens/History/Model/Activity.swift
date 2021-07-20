//
//  Activity.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

struct Activity {
    let id: String
    let createdAt: String
    let direction: Direction
    let from: String
    let to: String?
    let via: String
    let duration: String
    var isArchived: Bool
    let callType: CallType

    enum Direction {
        case inbound
        case outbound
    }

    enum CallType {
        case missed
        case voicemail
        case answered
    }

    mutating func unArchive() { isArchived = false }
    mutating func archive() { isArchived = true }
}
