//
//  ActivityDataSourceError.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

enum ActivityDataSourceError: Error {

    /// If data cannot be read
    /// The associated `Error` might describe more details from internal layers.
    case dataSourceAvailabilityProblem(Error?)

    /// If data was read, but model cannot be instantiated
    /// The associated `Error` might describe more details from internal layers.
    case dataConsistencyProblem(Error?)
}
