//
//  Result+Single.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

extension PrimitiveSequenceType where Trait == SingleTrait {
    func materialize() -> Single<Swift.Result<Element, Error>> {
        map { Swift.Result.success($0) }
        .catch { error in
            .just(Swift.Result.failure(error))
        }
    }

    func mapFailure<T, ErrorFrom, ErrorTo>(
        _ transform: @escaping (ErrorFrom) -> ErrorTo
    ) -> Single<Swift.Result<T, ErrorTo>> where Element == Swift.Result<T, ErrorFrom> {
        map {
            switch $0 {
            case let .success(data):
                return .success(data)
            case let .failure(error):
                return .failure(transform(error))
            }
        }
    }
}
