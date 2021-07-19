//
//  HistoryViewModelTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class HistoryViewModelTests: TestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var startTrigger: PublishSubject<Void>!
    private var didSelectActivityAtIndex: PublishSubject<Int>!
    private var didArchiveActivtyAtIndex: PublishSubject<Int>!
    private var didPressReset: PublishSubject<Void>!

    private var repository: HistoryRepository!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        disposeBag = .init()
        startTrigger = PublishSubject<Void>()
        didSelectActivityAtIndex = PublishSubject<Int>()
        didArchiveActivtyAtIndex = PublishSubject<Int>()
        didPressReset = PublishSubject<Void>()
    }

    // MARK: - Tests

    func testGivenAHistoryViewModel_WhenStartTrigger_WithSuccess_ItReturnsActivities() {
        let expectation = self.expectation(description: "Returned activities")
        repository = .successMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: { _ in }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .activities
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                XCTAssertFalse($0.isEmpty)
                XCTAssertFalse($0.contains(where: { $0.isArchived }))
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        startTrigger.onNext(())

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryViewModel_WhenStartTrigger_WithFailure_ItReturnsAlertDataSource() {
        let expectation = self.expectation(description: "Returned activities")
        expectation.isInverted = true
        let alertExpectation = self.expectation(description: "Returned Alert Data Source")
        repository = .failureMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: { _ in }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .activities
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                XCTFail()
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        outputs
            .alertDataSource
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                alertExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        startTrigger.onNext(())

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryViewModel_WhenReset_WithSuccess_ItReturnsActivities() {
        let expectation = self.expectation(description: "Returned activities")
        expectation.expectedFulfillmentCount = 2 // `activities` will emit 2 times.
        repository = .successMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: { _ in }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        var counter = 0
        outputs
            .activities
            .asDriverOnErrorJustComplete()
            .drive(onNext: { activities in
                if counter == 0 {
                    XCTAssertEqual(activities.count, 5)
                } else if counter == 1 {
                    XCTAssertEqual(activities.count, 6)
                }
                counter+=1
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        startTrigger.onNext(())
        didPressReset.onNext(())

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryViewModel_WhenReset_WithFailure_ItReturnsAlertDataSource() {
        let expectation = self.expectation(description: "Returned activities")
        let alertExpectation = self.expectation(description: "Returned Alert Data Source")
        repository = .failureResetMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: { _ in }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .activities
            .asDriverOnErrorJustComplete()
            .drive(onNext: { activities in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        outputs
            .alertDataSource
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                alertExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        startTrigger.onNext(())
        didPressReset.onNext(())

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryViewModel_WhenArchiveAnActivity_WithSuccess_ItReturnsFilteredActivities() {
        let expectation = self.expectation(description: "Returned activities")
        expectation.expectedFulfillmentCount = 2 // `activities` will emit 2 times.
        repository = .successMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: { _ in }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        var counter = 0
        outputs
            .activities
            .asDriverOnErrorJustComplete()
            .drive(onNext: { activities in
                if counter == 0 {
                    XCTAssertEqual(activities.count, 5)
                } else if counter == 1 {
                    XCTAssertEqual(activities.count, 4)
                }
                counter+=1
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        startTrigger.onNext(())
        didArchiveActivtyAtIndex.onNext(0)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryViewModel_WhenArchiveAnActivity_WithFailure_ItReturnsAlertDataSource() {
        let expectation = self.expectation(description: "Returned activities")
        let alertExpectation = self.expectation(description: "Returned Alert Data Source")
        repository = .failureArchiveMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: { _ in }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .activities
            .asDriverOnErrorJustComplete()
            .drive(onNext: { activities in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        outputs
            .alertDataSource
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                alertExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        startTrigger.onNext(())
        didArchiveActivtyAtIndex.onNext(0)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryViewModel_WhenSelectAnActivity_ItSendSelectAction() {
        let expectation = self.expectation(description: "Select activity action")
        repository = .successMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: {
                    XCTAssertEqual($0.id, "7834")
                    expectation.fulfill()
                }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .actions
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
            
        startTrigger.onNext(())
        didSelectActivityAtIndex.onNext(0)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryViewModel_WhenSelectAnActivityOnBadInndex_ItDoNothing() {
        let expectation = self.expectation(description: "Select unexisting activity action")
        expectation.isInverted = true
        repository = .successMock()

        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: { _ in
                    expectation.fulfill()
                }
            )
        )

        let inputs = makeMockInputs()
        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .actions
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
            
        startTrigger.onNext(())
        didSelectActivityAtIndex.onNext(100000000)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

private extension HistoryViewModelTests {
    func makeMockInputs() -> HistoryViewModel.Inputs {
        .init(
            startTrigger: startTrigger,
            didPressActivityAtIndex: didSelectActivityAtIndex,
            didArchiveActivtyAtIndex: didArchiveActivtyAtIndex,
            didPressReset: didPressReset
        )
    }
}

private extension HistoryRepository {
    static func successMock() -> HistoryRepository {
        return .init(
            getHistory: { .just(.success(mockHistoryResponse)) },
            archiveActivity: { _ in .just(.success(mockArchiveActivityResponse)) },
            reset: { .just(.success(mockResetResponse)) }
        )
    }

    static func failureMock() -> HistoryRepository {
        return .init(
            getHistory: { .just(.failure(HistoryError.generalError(nil))) },
            archiveActivity: { _ in .just(.failure(HistoryError.generalError(nil))) },
            reset: { .just(.failure(HistoryError.generalError(nil))) }
        )
    }

    static func failureResetMock() -> HistoryRepository {
        return .init(
            getHistory: { .just(.success(mockHistoryResponse)) },
            archiveActivity: { _ in .just(.success(mockArchiveActivityResponse)) },
            reset: { .just(.failure(HistoryError.generalError(nil))) }
        )
    }

    static func failureArchiveMock() -> HistoryRepository {
        return .init(
            getHistory: { .just(.success(mockHistoryResponse)) },
            archiveActivity: { _ in .just(.failure(HistoryError.generalError(nil))) },
            reset: { .just(.failure(HistoryError.generalError(nil))) }
        )
    }

    static let mockHistoryResponse = try! JSONDecoder().decode(HistoryResponse.self, from: MockData.activities)
    static let mockArchiveActivityResponse = try! JSONDecoder().decode(ArchiveActivityResponse.self, from: MockData.archiveActivity)
    static let mockResetResponse = try! JSONDecoder().decode(ResetResponse.self, from: MockData.reset)
}
