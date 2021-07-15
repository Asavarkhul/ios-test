//
//  Activity.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

struct Activity {
    let id: Int
    let createdAt: String
    let direction: String
    let from: String
    let to: String?
    let via: String
    let duration: String
    let isArchived: Bool
    let callType: String
}
