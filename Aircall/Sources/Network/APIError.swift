//
//  APIError.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

public enum APIError: Error {
    case networkProblem
    case invalidResponse(String?)
    case noData
    case badURLEncoding
}
