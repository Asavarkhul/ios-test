//
//  MockContext.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import Foundation
@testable import Aircall

final class MockContext: ContextType {

    let client: HTTPClientType
    let requestBuilder: RequestBuilderType
    let jsonParser: JSONParserType

    init() {
        self.client = MockClient(responses: .init(onSendRequest: .never()))
        requestBuilder = RequestBuilder()
        jsonParser = JSONParser()
    }
    
    static func build() -> ContextType {
        return MockContext()
    }
}
