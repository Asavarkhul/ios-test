//
//  Environment+XCtestCase.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 18/07/2021.
//

import XCTest
@testable import Aircall

class TestCase: XCTestCase {
    override func setUp() {
        super.setUp()
        Current = .mock
    }
}

private extension Environment {
    static let mock: Environment = {
        return Environment(
            translator: MockTranslator.readFromFile
        )
    }()
}
