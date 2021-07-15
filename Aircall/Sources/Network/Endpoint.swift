//
//  Endpoint.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

enum HTTPMethod {
    case GET
    case POST
}

protocol Endpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: [String: Any]? { get }
}
