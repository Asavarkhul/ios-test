//
//  HistoryError+APIError.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import Foundation

extension HistoryError {
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
