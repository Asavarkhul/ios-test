//
//  ResetEndpoint.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

struct ResetEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    var path: String = "https://aircall-job.herokuapp.com/reset"
    var queryParameters: [String : Any]? = nil
}
