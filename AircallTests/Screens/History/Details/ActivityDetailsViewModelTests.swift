//
//  ActivityDetailsViewModelTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class ActivityDetailsViewModelTests: TestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var startTrigger: PublishSubject<Void>!
    private var didPressArchive: PublishSubject<Void>!

    private var repository: ActivityRepository!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        disposeBag = .init()
        startTrigger = PublishSubject<Void>()
        didPressArchive = PublishSubject<Void>()
    }

    // MARK: - Tests

    func testGivenAnActivityDetailsViewModel_WhenStartTrigger_WithSuccess_ItReturnsActivities() {
        let expectation = self.expectation(description: "Returned items")
        repository = .successMock()

        let viewModel = ActivityViewModel(
            activity: mockActivity,
            actions: .init(onArchive: {}),
            repository: repository
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .items
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        outputs
            .actions
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)

        startTrigger.onNext(())

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAnActivityDetailsViewModel_WhenArchiveAnActivity_WithSuccess_ItReturnsAction() {
        let expectation = self.expectation(description: "Returned action")
        repository = .successMock()

        let viewModel = ActivityViewModel(
            activity: mockActivity,
            actions: .init(onArchive: {
                expectation.fulfill()
            }),
            repository: repository
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .actions
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)

        startTrigger.onNext(())
        didPressArchive.onNext(())

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAnActivityDetailsViewModel_WhenArchiveAnActivity_WithFailure_ItReturnedDialogAlertDataSource() {
        let expectation = self.expectation(description: "Returned Alert Data Source")
        repository = .failureMock()

        let viewModel = ActivityViewModel(
            activity: mockActivity,
            actions: .init(onArchive: {
                XCTFail()
            }),
            repository: repository
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .alertDataSource
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        outputs
            .actions
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)

        startTrigger.onNext(())
        didPressArchive.onNext(())

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

private extension ActivityDetailsViewModelTests {
    var mockActivity: Activity {
        .init(
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
    }
}

private extension ActivityDetailsViewModelTests {
    func makeMockInputs() -> ActivityViewModel.Inputs {
        .init(
            startTrigger: startTrigger,
            didPressArchive: didPressArchive
        )
    }
}

private extension ActivityRepository {
    static func successMock() -> ActivityRepository {
        return .init(
            archiveActivity: { _ in .just(.success(mockArchiveActivityResponse)) }
        )
    }

    static func failureMock() -> ActivityRepository {
        return .init(
            archiveActivity: { _ in .just(.failure(HistoryError.generalError(nil))) }
        )
    }

    static let mockArchiveActivityResponse = try! JSONDecoder().decode(ArchiveActivityResponse.self, from: MockData.archiveActivity)
}
