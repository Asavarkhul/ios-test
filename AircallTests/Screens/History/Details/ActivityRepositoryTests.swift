//
//  ActivityRepositoryTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class ActivityRepositoryTests: TestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var repository: ActivityRepository!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        disposeBag = .init()
    }

    // MARK: - Tests

    func testGivenAnActivitRepository_WhenSuccessfullyArchiveActivity_ItReturnsResponse() {
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

    func testGivenAnActivityRepository_WhenFailArchiveActivity_ItReturnsError() {
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

}

private extension MockClient.Responses {
    static var successArchiveActivity: MockClient.Responses {
        MockClient.Responses(
            onSendRequest: .just(MockData.archiveActivity)
        )
    }

    static var failure: MockClient.Responses {
        MockClient.Responses(
            onSendRequest: .error(APIError.noData)
        )
    }
}
