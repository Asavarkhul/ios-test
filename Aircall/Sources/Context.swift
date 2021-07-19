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
final class Context {

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

    class func build() -> Context {
        return Context()
    }
}
