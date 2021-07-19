//
//  MockTranslator.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import Foundation
@testable import Aircall

final class MockTranslator: TranslatorType {

    // MARK: - Properties

    private var translations: Translations!

    // MARK: - Initializer

    init(translations: Translations = [:]) {
        self.translations = translations
    }

    init(translationsFileURL: URL) {
        translations = readFile(translationsFileURL)
    }

    // MARK: - Configuration

    public func translation(for key: String) -> String {
        translations[key] ?? key
    }

    private func readFile(_ url: URL) -> Translations {
        guard let keyValues = NSDictionary(contentsOf: url) else { return [:] }
        var translations = Translations()
        keyValues.forEach { item in
            guard let key = item.key as? String, let value = item.value as? String else { return }
            translations[key] = value
        }
        return translations
    }
}

extension MockTranslator {
    /// MockTranslator object which has no translation values.
    /// It will return a raw `key` when asking for the translation.
    /// - Returns: MockTranslator object.
    static var empty: MockTranslator { .init() }

    /// MockTranslator object which reads the fake translations from a given dictionary.
    /// - Parameters:
    ///   - translations: The translation key values.
    /// - Returns: MockTranslator object.
    static func mock(translations: Translations) -> MockTranslator {
        MockTranslator(translations: translations)
    }

    /// MockTranslator object which reads the fake translations from a file.
    /// - Parameters:
    ///   - translationsFileURL: The url path to the file that contains translation key values.
    /// - Returns: MockTranslator object.
    static func mock(translationsFileURL: URL) -> MockTranslator {
        MockTranslator(translationsFileURL: translationsFileURL)
    }
}

