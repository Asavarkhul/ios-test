//
//  NetworkTableViewCellTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import XCTest
import SnapshotTesting
@testable import Aircall

final class NetworkTableViewCellTests: TestCase {

    // MARK: - Properties

    private var cell: NetworkTableViewCell!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        isRecording = false
        cell = NetworkTableViewCell()
    }

    // MARK: - Tests

    func testCreatesNetworkTableViewCell_ForInBoundCall() {
        cell.configure(with: .inboud)
        snapshotCell(cell)
    }

    func testCreatesNetworkTableViewCell_ForOutbound() {
        cell.configure(with: .outbound)
        snapshotCell(cell)
    }
}

private extension NetworkViewModel {
    static var inboud: NetworkViewModel {
        return .init(
            activity: .init(
                id: "123",
                createdAt: "2018-04-18T16:59:48.000Z",
                direction: .inbound,
                from: "Inspector Gadget 🕵️‍♂️",
                to: "Santa Claus 🎅",
                via: "Aircall",
                duration: "12",
                isArchived: false,
                callType: .missed
            )
        )
    }

    static var outbound: NetworkViewModel {
        return .init(
            activity: .init(
                id: "123",
                createdAt: "2018-04-18T16:59:48.000Z",
                direction: .outbound,
                from: "Inspector Gadget 🕵️‍♂️",
                to: "Santa Claus 🎅",
                via: "Aircall",
                duration: "12",
                isArchived: false,
                callType: .missed
            )
        )
    }
}
