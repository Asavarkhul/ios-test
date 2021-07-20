//
//  ActivityDetailsRepository.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

struct ActivityRepository {
    var archiveActivity: (_ id: String) -> Single<Result<ArchiveActivityResponse, Error>>
}

extension ActivityRepository {

    // MARK: - Live

    static func live(
        requestBuilder: RequestBuilderType,
        client: HTTPClientType,
        parser: JSONParserType
    ) -> ActivityRepository {
        return .init(
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
                    .mapFailure { HistoryError($0) }
            }
        )
    }
}
