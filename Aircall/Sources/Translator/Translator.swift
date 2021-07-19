//
//  Translator.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 18/07/2021.
//

import Foundation

typealias Translations = [String: String]

// MARK: - Protocol

protocol TranslatorType {
    ///
    /// - Parameter key: unique key which identifies translated content
    func translation(for key: String) -> String
}

extension TranslatorType {
    func translationByReplacingVariables(for key: String, `var`: String) -> String {
        translation(for: key).replacingOccurrences(of: "$var", with: `var`)
    }
}

// MARK: - Errors

enum TranslatorError: Error {
    case unexistingPathForRessource(String)
}

/// Translator is the tool 🛠 for handling translations in the app.
/// It's made as a signleton, since it's spread in the app without injection needs.
final class Translator: TranslatorType {

    // MARK: - Properties

    static var configuredTranslator: TranslatorType?
    static let failbackTranslator: TranslatorType = KeyValueTranslator()
    static var shared: TranslatorType { configuredTranslator ?? failbackTranslator }

    private static var bundleStorages: BundleStorageType?

    // MARK: - Initializer

    init(directory: URL) throws {
        Self.bundleStorages = try BundleStorage(directory: directory)
    }

    // MARK: - Configure

    static func configure(for ressource: String, in bundle: Bundle) throws {
        guard let path = bundle.path(forResource: ressource, ofType: "strings") else {
            throw TranslatorError.unexistingPathForRessource(ressource)
        }
        let url = URL(fileURLWithPath: path)
        configuredTranslator = try Translator(directory: url)
    }

    // MARK: - Translation

    func translation(for key: String) -> String {
        Self.bundleStorages?.translation(for: key) ?? key
    }
}

private final class KeyValueTranslator: TranslatorType {
    init() {}

    func translation(for key: String) -> String {
        assertionFailure(
            "You should not use this key value translator. It may be caused because you didn't call Translator.configure(...) before Translator.shared.translation(for:)"
        )
        return key
    }
}
