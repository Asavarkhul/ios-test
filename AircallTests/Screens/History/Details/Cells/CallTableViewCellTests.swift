//
//  CallTableViewCellTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import XCTest
import SnapshotTesting
@testable import Aircall

final class CallTableViewCellTests: TestCase {

    // MARK: - Properties

    private var cell: CallTableViewCell!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        isRecording = false
        cell = CallTableViewCell()
    }

    // MARK: - Tests

    // MARK: - Tests

    func testCreatesMissedInboud() {
        cell.configure(with: .missedInboud)
        snapshotCell(cell)
    }

    func testCreatesMissedOutbound() {
        cell.configure(with: .missedOutbound)
        snapshotCell(cell)
    }

    func testCreatesAnsweredInbound() {
        cell.configure(with: .answeredInbound)
        snapshotCell(cell)
    }

    func testCreatesAnsweredOutbound() {
        cell.configure(with: .answeredOutbound)
        snapshotCell(cell)
    }

    func testCreatesVoiceMailInbound() {
        cell.configure(with: .voicemailInbound)
        snapshotCell(cell)
    }

    func testCreatesVoicemailOutbound() {
        cell.configure(with: .voicemailOutbound)
        snapshotCell(cell)
    }
}

private extension CallViewModel {
    static var missedInboud: CallViewModel {
        return .init(
            activity: .init(
                id: "",
                createdAt: "",
                direction: .inbound,
                from: "",
                to: "",
                via: "",
                duration: "",
                isArchived: false,
                callType: .missed
            )
        )
    }

    static var missedOutbound: CallViewModel {
        return .init(
            activity: .init(
                id: "",
                createdAt: "",
                direction: .outbound,
                from: "",
                to: "",
                via: "",
                duration: "",
                isArchived: false,
                callType: .missed
            )
        )
    }

    static var answeredOutbound: CallViewModel {
        return .init(
            activity: .init(
                id: "",
                createdAt: "",
                direction: .inbound,
                from: "",
                to: "",
                via: "",
                duration: "",
                isArchived: false,
                callType: .answered
            )
        )
    }

    static var answeredInbound: CallViewModel {
        return .init(
            activity: .init(
                id: "",
                createdAt: "",
                direction: .outbound,
                from: "",
                to: "",
                via: "",
                duration: "",
                isArchived: false,
                callType: .answered
            )
        )
    }

    static var voicemailInbound: CallViewModel {
        return .init(
            activity: .init(
                id: "",
                createdAt: "",
                direction: .inbound,
                from: "",
                to: "",
                via: "",
                duration: "",
                isArchived: false,
                callType: .voicemail
            )
        )
    }

    static var voicemailOutbound: CallViewModel {
        return .init(
            activity: .init(
                id: "",
                createdAt: "",
                direction: .outbound,
                from: "",
                to: "",
                via: "",
                duration: "",
                isArchived: false,
                callType: .voicemail
            )
        )
    }
}

