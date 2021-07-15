//
//  IntegrationTestsCheck.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

/// Own informations about integration test status.
enum IntegrationTests {

    /// Tell if integration tests are enabled.
    static var isEnabled: Bool {
        ProcessInfo.processInfo.environment["IS_RUNNING_INTEGRATION_TESTS"] == "YES"
    }
}
