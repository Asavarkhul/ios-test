//
//  Context.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

/// Context is our bag of dependencies 🎒
/// This is the place where you'll want to instanciate all of your dependencies
/// in order to inject them everywhere and keep a perfect testable/scalable architecture 👌
protocol ContextType: AnyObject {
    var client: HTTPClientType { get }
    var requestBuilder: RequestBuilderType { get }
    var jsonParser: JSONParserType { get }

    static func build() -> ContextType
}

final class Context: ContextType {

    // MARK: - Properties

    let client: HTTPClientType
    let requestBuilder: RequestBuilderType
    let jsonParser: JSONParserType

    // MARK: - Initializer

    private init() {
        self.client = HTTPClient()
        self.requestBuilder = RequestBuilder()
        self.jsonParser = JSONParser()
    }

    // MARK: - Build

    static func build() -> ContextType {
        return Context()
    }
}
