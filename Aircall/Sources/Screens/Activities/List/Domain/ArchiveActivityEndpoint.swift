//
//  ArchiveActivityEndpoint.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

struct ArchiveActivityEndpoint: Endpoint {
    var method: HTTPMethod = .POST
    var path: String
    var queryParameters: [String : Any]?

    init(id: String) {
        self.path = "https://aircall-job.herokuapp.com/activities/\(id)"
        self.queryParameters = ["is_archived": true]
    }
}
