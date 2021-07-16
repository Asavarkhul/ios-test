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
    let direction: String
    let from: String
    let to: String?
    let via: String
    let duration: String
    var isArchived: Bool
    let callType: String

    mutating func unArchive() { isArchived = false }
    mutating func archive() { isArchived = true }
}
