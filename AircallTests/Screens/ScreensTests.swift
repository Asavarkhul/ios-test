//
//  ScreensTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import XCTest
@testable import Aircall

final class ScreensTests: XCTestCase {

    // MARK: - Properties

    private var context: ContextType!
    private var screens: Screens!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        context = MockContext.build()
        screens = Screens(context: context)
    }

    // MARK: - Tests

    func testThatCreatesHistory() {
        let sut = screens.createHistory(onSelectActivity: { _ in })
        XCTAssertNotNil(sut)
    }

    func testThatCreatesDetails() {
        let sut = screens.createDetails(for: .init())
        XCTAssertNotNil(sut)
    }
}

private extension Activity {
    init() {
        self.init(
            id: "",
            createdAt: "",
            direction: .inbound,
            from: "",
            to: "",
            via: "",
            duration: "",
            isArchived: true,
            callType: .answered
        )
    }
}
