//
//  BundleStorage.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 18/07/2021.
//

import Foundation

// MARK: - Protocol

protocol BundleStorageType {
    func translation(for key: String) -> String?
}

// MARK: - Errors

enum BundleStorageError: Error {
    case invalidLocalizableDirectoryURL(String)
}

class BundleStorage: BundleStorageType {

    // MARK: - Properties

    private let bundle: Bundle

    // MARK: - Initializer

    init(directory: URL) throws {
        guard let bundle = Bundle(url: directory.deletingLastPathComponent()) else {
            throw BundleStorageError.invalidLocalizableDirectoryURL(
                "Unexisting Localizable directory URL: \(directory.path)"
            )
        }
        self.bundle = bundle
    }

    // MARK: - Translation

    func translation(for key: String) -> String? {
        let result = bundle.localizedString(forKey: key, value: nil, table: nil)
        return result == key ? nil : result
    }
}

