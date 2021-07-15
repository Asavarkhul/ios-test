//
//  JSONParserTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import XCTest
import RxSwift
@testable import Aircall

final class JSONParserTests: XCTestCase {

    // MARK: - Properties

    private var disposeBag: DisposeBag!
    private var parser: JSONParser!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        disposeBag = .init()
        parser = .init()
    }

    // MARK: - Tests

    func testGivenAValidResponse_ThenParserReturnsExpectedResult() {
        let expectation = self.expectation(description: "Parsed Json from Data")
        let expectedResult = CodableExample(
            title: "HELLO",
            subTitle: "JOJO"
        )
        
        let sut: Observable<CodableExample> = parser.processCodableResponse(
            from: JSONParserTests.validJSONData
        )
            
        sut.subscribe(
            onNext: { result in
                XCTAssertEqual(result, expectedResult)
                expectation.fulfill()
            },
            onError: { _ in
                XCTFail()
            }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGivenANonValidResponse_ThenParserReturnsInvalidResponseError() {
        let expectation = self.expectation(description: "Invalid response Error")
        let sut: Observable<CodableExample> = parser.processCodableResponse(
            from: JSONParserTests.nonValidJSONData
        )
            
        sut.subscribe(
            onNext: { result in
                XCTFail()
            },
            onError: { error in
                if case APIError.invalidResponse = error {
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

private extension JSONParserTests {
    struct CodableExample: Codable, Equatable {
        let title: String
        let subTitle: String
    }

    static var validJSONData = """
    {
        "title": "HELLO",
        "subTitle": "JOJO"
    }
    """.data(using: .utf8)!

    static var nonValidJSONData = "{}".data(using: .utf8)!
}
