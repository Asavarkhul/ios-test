//
//  ResetResponse.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

// MARK: - ResetResponse
struct ResetResponse: Decodable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}
