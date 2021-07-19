//
//  Mocktranslator+MockLocalizable.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import Foundation
@testable import Aircall

extension MockTranslator {
    static let readFromFile = MockTranslator.mock(
        translationsFileURL: URL(
            fileURLWithPath: Bundle.test.path(forResource: "Localizable", ofType: ".strings")!
        )
    )
}
