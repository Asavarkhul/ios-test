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
}
