//
//  Result+Single.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

extension PrimitiveSequenceType where Trait == SingleTrait {
    
    /// Continues an observable sequence which will be mapped to `Swift.Result`
    /// Any error in the observable sequence will be catched and pickup in a `Result.failure()` case.
    /// - Returns: An observable sequence containing the source sequence’s elements, encapsulated in a `Swift.Result` case.
    func materialize() -> Single<Swift.Result<Element, Error>> {
        map { Swift.Result.success($0) }
        .catch { error in
            .just(Swift.Result.failure(error))
        }
    }
    
    /// Continues an observable sequence which will transform error case to a custom Error
    /// - Parameter transform: The custom `Error` pattern to apply
    /// - Returns: An observable sequence containing the source sequence’s elements, encapsulated in a `Swift.Result` case,
    /// and in case of an error case, transformed through the desired pattern.
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
