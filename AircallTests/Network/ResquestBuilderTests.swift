//
//  ResquestBuilderTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class ResquestBuilderTests: XCTestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var builder: RequestBuilder!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        disposeBag = .init()
        builder = .init()
    }

    // MARK: - Tests

    func testGivenABuilderWithValidEndpoint_ThenItReturnsAnURLRequest() {
        let expectation = self.expectation(description: "Valid URL Request")
        let endpoint = ValidGetEndpoint()
        let sut = builder.build(from: endpoint)

        sut.subscribe(
            onNext: {
                XCTAssertEqual($0.url!.absoluteString, "https://www.google.com")
                expectation.fulfill()
            },
            onError: { _ in XCTFail() }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenABuilderWithNonValidEndpoint_ThenItReturnsAnError() {
        let expectation = self.expectation(description: "Bad URL Encoding error")
        let endpoint = NonValidGetEndpoint()
        let sut = builder.build(from: endpoint)

        sut.subscribe(
            onNext: { _ in XCTFail() },
            onError: { error in
                if case APIError.badURLEncoding = error {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

private extension ResquestBuilderTests {
    struct ValidGetEndpoint: Endpoint {
        var method: HTTPMethod = .GET
        var path: String = "https://www.google.com"
        var queryParameters: [String : Any]? = nil
    }

    struct NonValidGetEndpoint: Endpoint {
        var method: HTTPMethod = .GET
        var path: String = "Hello Jojo 👋"
        var queryParameters: [String : Any]? = nil
    }
}
