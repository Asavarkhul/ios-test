//
//  TranslatorTests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import XCTest
@testable import Aircall

final class TranslatorTests: XCTestCase {

    func testWhenRessourceIfFoundInBundle_ItDoesNotThrow() {
        XCTAssertNoThrow(try Translator.configure(for: "Localizable", in: .test))
    }

    func testThatThrowAnError_WhenFileIsNotFoundInBundle() {
        XCTAssertThrowsError(try Translator.configure(for: "UnexistingFileName", in: .test))
    }

    func testThatValueIsCorrectlyReturned_WhenKeyIsFoundInFile() {
        try! Translator.configure(for: "Localizable", in: .test)
        XCTAssertEqual(Translator.shared.translation(for: "mobile/history/title.text"), "History 🧑‍🏫")
    }

    func testWhenKeyIsNotFound_ItReturnItself() {
        try! Translator.configure(for: "Localizable", in: .test)
        XCTAssertEqual(Translator.shared.translation(for: "bad/key/provided.text"), "bad/key/provided.text")
    }
}
