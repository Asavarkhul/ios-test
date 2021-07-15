//
//  HTTPClientTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class HTTPClientTests: XCTestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var client: HTTPClient!
    private var builder: RequestBuilder!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        disposeBag = .init()
        client = .init()
        builder = .init()
    }

    // MARK: - Tests

    func testWhenSendingGetRequest_itReceivesValidResponse() {
        let expectation = self.expectation(description: "Received data response")
        let request = builder.build(from: ValidGetEndpoint())
        
        retry(
            block: { (retry, fulfill) in
                request
                    .flatMap { self.client.send(request: $0) }
                    .subscribe(
                        onNext: { _ in fulfill() },
                        onError: { _ in retry() })
                    .disposed(by: self.disposeBag)
            },
            untilItFulfillsExpectation: expectation, orNumberOfTimes: 3
        )

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testWhenSendingGetRequest_IfDataIsNilOrEmpty_ThenANoDataErrorIsReached() {
        let expectation = self.expectation(description: "No Data Error")
        let request = builder.build(from: ValidGetWithNoDataEndpoint())
        
        retry(
            block: { (retry, fulfill) in
                request
                    .flatMap { self.client.send(request: $0) }
                    .subscribe(
                        onNext: { _ in retry() },
                        onError: { error in
                            if case APIError.noData = error {
                                fulfill()
                            } else {
                                XCTFail()
                            }
                        })
                    .disposed(by: self.disposeBag)
            },
            untilItFulfillsExpectation: expectation, orNumberOfTimes: 3
        )

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testWhenSendingGetRequest_IfNilResponseOrBadHTTPStatusCode_ThenANetworkProblemErrorIsReached() {
        let expectation = self.expectation(description: "Network problem Error")
        let request = builder.build(from: ClientErrorEndpoint())
        
        retry(
            block: { (retry, fulfill) in
                request
                    .flatMap { self.client.send(request: $0) }
                    .subscribe(
                        onNext: { _ in retry() },
                        onError: { error in
                            if case APIError.networkProblem = error {
                                fulfill()
                            } else {
                                XCTFail()
                            }
                        })
                    .disposed(by: self.disposeBag)
            },
            untilItFulfillsExpectation: expectation, orNumberOfTimes: 3
        )

        waitForExpectations(timeout: 10, handler: nil)
    }
}

private extension HTTPClientTests {
    struct ValidGetEndpoint: Endpoint {
        var method: HTTPMethod = .GET
        var path: String = "https://httpbin.org"
        var queryParameters: [String : Any]? = nil
    }

    struct ValidGetWithNoDataEndpoint: Endpoint {
        var method: HTTPMethod = .GET
        var path: String = "https://httpbin.org/bytes/0"
        var queryParameters: [String : Any]? = nil
    }

    struct ClientErrorEndpoint: Endpoint {
        var method: HTTPMethod = .GET
        var path: String = "https://httpbin.org/status/400"
        var queryParameters: [String : Any]? = nil
    }
}
