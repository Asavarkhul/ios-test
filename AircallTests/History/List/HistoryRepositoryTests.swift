//
//  HistoryRepositoryTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class HistoryRepositoryTests: XCTestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var repository: HistoryRepository!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        disposeBag = .init()
    }

    // MARK: - Tests

    func testGivenAHistoryRepository_WhenSuccessfullyGetActivities_ItReturnsResponse() {
        let expectation = self.expectation(description: "Success Get Activities")
        repository = .live(
            requestBuilder: RequestBuilder(),
            client: MockClient(responses: .successGetActivities),
            parser: JSONParser()
        )

        let sut = repository.getHistory()

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success:
                    expectation.fulfill()
                case .failure: XCTFail()
                }
            },
            onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryRepository_WhenSuccessfullyArchiveActivity_ItReturnsResponse() {
        let expectation = self.expectation(description: "Success Archive Activity")
        repository = .live(
            requestBuilder: RequestBuilder(),
            client: MockClient(responses: .successArchiveActivity),
            parser: JSONParser()
        )

        let sut = repository.archiveActivity("7831")

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success:
                    expectation.fulfill()
                case .failure: XCTFail()
                }
            },
            onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryRepository_WhenSuccessfullyReset_ItReturnsResponse() {
        let expectation = self.expectation(description: "Failure Archive Activity")
        repository = .live(
            requestBuilder: RequestBuilder(),
            client: MockClient(responses: .successReset),
            parser: JSONParser()
        )

        let sut = repository.reset()

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success:
                    expectation.fulfill()
                case .failure: XCTFail()
                }
            },
            onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryRepository_WhenFailGetActivities_ItReturnsError() {
        let expectation = self.expectation(description: "Failure Get Activities")
        repository = .live(
            requestBuilder: RequestBuilder(),
            client: MockClient(responses: .failure),
            parser: JSONParser()
        )

        let sut = repository.getHistory()

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success: XCTFail()
                case .failure(let error):
                    if case HistoryError.dataConsistencyProblem = error {
                        expectation.fulfill()
                    } else {
                        XCTFail()
                    }
                }
            }, onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryRepository_WhenFailArchiveActivity_ItReturnsError() {
        let expectation = self.expectation(description: "Failure Archive Activity")
        repository = .live(
            requestBuilder: RequestBuilder(),
            client: MockClient(responses: .failure),
            parser: JSONParser()
        )

        let sut = repository.archiveActivity("123")

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success: XCTFail()
                case .failure(let error):
                    if case HistoryError.dataConsistencyProblem = error {
                        expectation.fulfill()
                    } else {
                        XCTFail()
                    }
                }
            }, onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenAHistoryRepository_WhenFailReset_ItReturnsError() {
        let expectation = self.expectation(description: "Failure Archive Activity")
        repository = .live(
            requestBuilder: RequestBuilder(),
            client: MockClient(responses: .failure),
            parser: JSONParser()
        )

        let sut = repository.reset()

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success: XCTFail()
                case .failure(let error):
                    if case HistoryError.dataConsistencyProblem = error {
                        expectation.fulfill()
                    } else {
                        XCTFail()
                    }
                }
            }, onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

private extension MockClient.Responses {
    static var successGetActivities: MockClient.Responses {
        MockClient.Responses(
            onSendRequest: .just(MockData.activities)
        )
    }

    static var successArchiveActivity: MockClient.Responses {
        MockClient.Responses(
            onSendRequest: .just(MockData.archiveActivity)
        )
    }

    static var successReset: MockClient.Responses {
        MockClient.Responses(
            onSendRequest: .just(MockData.reset)
        )
    }

    static var failure: MockClient.Responses {
        MockClient.Responses(
            onSendRequest: .error(APIError.noData)
        )
    }
}

private enum MockData {
    static var activities: Data {
        let path = Bundle.test.path(forResource: "HistoryResponse", ofType: ".json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }

    static var archiveActivity: Data {
        let path = Bundle.test.path(forResource: "ArchiveActivityResponse", ofType: ".json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }

    static var reset: Data {
        let path = Bundle.test.path(forResource: "ResetResponse", ofType: ".json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}
