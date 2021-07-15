//
//  ActivitiesEndpoint.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

struct ActivitiesEndpoint: Endpoint {
    var method: HTTPMethod = .GET
    var path: String = "https://aircall-job.herokuapp.com/activities"
    var queryParameters: [String : Any]? = nil
}
