//
//  MockData.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import Foundation

enum MockData {
    static var activities: Data {
        let path = Bundle.test.path(forResource: "HistoryResponse", ofType: ".json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }

    static var archiveActivity: Data {
        let path = Bundle.test.path(forResource: "ArchiveActivityResponse", ofType: ".json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }

    static var reset: Data {
        let path = Bundle.test.path(forResource: "ResetResponse", ofType: ".json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}
