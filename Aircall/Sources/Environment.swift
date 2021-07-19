//
//  Environment.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 18/07/2021.
//

import Foundation

/// `Environment` is responsible to provide modules which don't necessary needs to be injected. 💉
struct Environment {
    var translator: TranslatorType
    var locale = { Locale(identifier: "fr_FR") }
}

extension Environment {
    static let live = Environment(
        translator: Translator.shared
    )
}

var Current = Environment.live
