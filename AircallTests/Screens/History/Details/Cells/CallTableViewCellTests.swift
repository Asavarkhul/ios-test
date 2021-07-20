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

    func testCreatesCallTableViewCell_MissedInboud() {
        cell.configure(with: .missedInboud)
        snapshotCell(cell)
    }

    func testCreatesCallTableViewCell_MissedOutbound() {
        cell.configure(with: .missedOutbound)
        snapshotCell(cell)
    }

    func testCreatesCallTableViewCell_AnsweredInbound() {
        cell.configure(with: .answeredInbound)
        snapshotCell(cell)
    }

    func testCreatesCallTableViewCell_AnsweredOutbound() {
        cell.configure(with: .answeredOutbound)
        snapshotCell(cell)
    }

    func testCreatesCallTableViewCell_VoiceMailInbound() {
        cell.configure(with: .voicemailInbound)
        snapshotCell(cell)
    }

    func testCreatesCallTableViewCell_VoicemailOutbound() {
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

