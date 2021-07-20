//
//  HeaderTableViewCellTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import XCTest
import SnapshotTesting
@testable import Aircall

final class HeaderTableViewCellTests: TestCase {

    // MARK: - Properties

    private var cell: HeaderTableViewCell!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        isRecording = false
        cell = HeaderTableViewCell()
    }

    // MARK: - Tests

    func testThatCreatesHeaderTableViewCell() {
        cell.configure(with: "Hello Title World")
        snapshotCell(cell)
    }
}
