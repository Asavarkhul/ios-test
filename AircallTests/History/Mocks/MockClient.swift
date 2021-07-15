//
//  MockClient.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift
@testable import Aircall

final class MockClient: HTTPClientType {
    let responses: Responses

    struct Responses {
        let onSendRequest: Observable<Data>
    }

    init(responses: Responses) {
        self.responses = responses
    }

    func send(request: URLRequest) -> Observable<Data> { responses.onSendRequest }
}
