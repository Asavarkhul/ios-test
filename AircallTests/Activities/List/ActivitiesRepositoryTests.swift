//
//  ActivitiesRepositoryTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class ActivitiesRepositoryTests: XCTestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var repository: ActivitiesRepository!

    override func setUp() {
        super.setUp()
        disposeBag = .init()
        repository = .live(
            requestBuilder: RequestBuilder(),
            client: HTTPClient(),
            parser: JSONParser()
        )
    }

    func test() {
        let expectation = self.expectation(description: "Valid")
        let sut = repository.getActivities()

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success(let response):
                    print(response)
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            },
            onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testToto() {
        let expectation = self.expectation(description: "Valid")
        let sut = repository.archiveActivity("7831")

        sut.subscribe(
            onSuccess: { result in
                switch result {
                case .success(let response):
                    print(response)
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            },
            onFailure: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

