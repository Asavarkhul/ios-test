//
//  RequestBuilder.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

protocol RequestBuilderType: AnyObject {
    func build(from endpoint: Endpoint) -> Observable<URLRequest>
}

final class RequestBuilder: RequestBuilderType {

    // MARK: - RequestBuilderType protocol

    func build(from endpoint: Endpoint) -> Observable<URLRequest> {
        do {
            let request: URLRequest = try self.build(from: endpoint)
            return Observable.just(request)
        } catch {
            return Observable.error(error)
        }
    }

    // MARK: - Private

    private func build(from endpoint: Endpoint) throws -> URLRequest {
        guard let url = url(from: endpoint.path) else {
            throw APIError.badURLEncoding
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let queryParameters = endpoint.queryParameters {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: queryParameters,
                options: .prettyPrinted
            )
        }
        return request
    }

    private func url(from path: String) -> URL? {
        guard let components = URLComponents(string: path) else {
            return nil
        }
        return components.url
    }
}

