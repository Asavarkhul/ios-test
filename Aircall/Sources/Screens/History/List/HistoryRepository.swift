//
//  HistoryRepository.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

struct HistoryRepository {
    var getHistory: () -> Single<Result<HistoryResponse, Error>>
    var archiveActivity: (_ id: String) -> Single<Result<ArchiveActivityResponse, Error>>
    var reset: () -> Single<Result<ResetResponse, Error>>
}

extension HistoryRepository {

    // MARK: - Live
    
    static func live(
        requestBuilder: RequestBuilderType,
        client: HTTPClientType,
        parser: JSONParserType
    ) -> HistoryRepository {
        return .init(
            getHistory: {
                let endpoint = HistoryEndpoint()
                return requestBuilder
                    .build(from: endpoint)
                    .flatMap { client.send(request: $0) }
                    .flatMap { data -> Observable<HistoryResponse> in
                        parser.processCodableResponse(from: data)
                    }
                    .asSingle()
                    .materialize()
                    .mapFailure { HistoryError($0) }
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
                    .mapFailure { HistoryError($0) }
            },
            reset: {
                let endpoint = ResetEndpoint()
                return requestBuilder
                    .build(from: endpoint)
                    .flatMap { client.send(request: $0) }
                    .flatMap { data -> Observable<ResetResponse> in
                        parser.processCodableResponse(from: data)
                    }
                    .asSingle()
                    .materialize()
                    .mapFailure { HistoryError($0) }
            }
        )
    }
}

private extension HistoryError {
    init(_ error: Error) {
        guard let apiError = error as? APIError else {
            self = .generalError(error)
            return
        }
        switch apiError {
        case .networkProblem:
            self = .dataSourceAvailabilityProblem(apiError)
        case .invalidResponse, .badURLEncoding, .noData:
            self = .dataConsistencyProblem(apiError)
        }
    }
}
