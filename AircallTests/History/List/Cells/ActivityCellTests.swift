//
//  ActivityCellTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import XCTest
import SnapshotTesting
@testable import Aircall

final class ActivityCellTests: TestCase {

    override func setUp() {
        super.setUp()
        isRecording = false
    }

    func testCreatesMissedInboud() {
        let cell = ActivityTableViewCell()
        cell.configure(with: .missedInboud)
        snapshotCell(cell)
    }

    func testCreatesMissedOutbound() {
        let cell = ActivityTableViewCell()
        cell.configure(with: .missedOutbound)
        snapshotCell(cell)
    }

    func testCreatesAnsweredInbound() {
        let cell = ActivityTableViewCell()
        cell.configure(with: .answeredInbound)
        snapshotCell(cell)
    }

    func testCreatesAnsweredOutbound() {
        let cell = ActivityTableViewCell()
        cell.configure(with: .answeredOutbound)
        snapshotCell(cell)
    }

    func testCreatesVoiceMailInbound() {
        let cell = ActivityTableViewCell()
        cell.configure(with: .voicemailInbound)
        snapshotCell(cell)
    }

    func testCreatesVoicemailOutbound() {
        let cell = ActivityTableViewCell()
        cell.configure(with: .voicemailOutbound)
        snapshotCell(cell)
    }
}

private extension ActivityCellViewModel {
    static var missedInboud: ActivityCellViewModel {
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

    static var missedOutbound: ActivityCellViewModel {
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

    static var answeredOutbound: ActivityCellViewModel {
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
                callType: .answered
            )
        )
    }

    static var answeredInbound: ActivityCellViewModel {
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
                callType: .answered
            )
        )
    }

    static var voicemailInbound: ActivityCellViewModel {
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
                callType: .voicemail
            )
        )
    }

    static var voicemailOutbound: ActivityCellViewModel {
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
                callType: .voicemail
            )
        )
    }
}
