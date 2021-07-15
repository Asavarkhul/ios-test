//
//  ActivitiesRepository.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

struct ActivitiesRepository {
    var getActivities: () -> Single<Result<ActivitiesResponse, Error>>
    var archiveActivity: (_ id: String) -> Single<Result<ArchiveActivityResponse, Error>>
}

extension ActivitiesRepository {

    // MARK: - Live

    static func live(
        requestBuilder: RequestBuilderType,
        client: HTTPClientType,
        parser: JSONParserType
    ) -> ActivitiesRepository {
        return .init(
            getActivities: {
                let endpoint = ActivitiesEndpoint()
                return requestBuilder
                    .build(from: endpoint)
                    .flatMap { client.send(request: $0) }
                    .flatMap { data -> Observable<ActivitiesResponse> in
                        parser.processCodableResponse(from: data)
                    }
                    .asSingle()
                    .materialize()
            },
            archiveActivity: { id in
                let endpoint = ArchiveActivityEndpoint(id: id)
                return requestBuilder
                    .build(from: endpoint)
                    .flatMap { client.send(request: $0) }
                    .flatMap { data -> Observable<ArchiveActivityResponse> in
                        parser.processCodableResponse(from: data)
                    }
                    .asSingle()
                    .materialize()
            }
        )
    }
}
