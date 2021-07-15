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
        guard let url = url(from: endpoint.path, queryParameters: endpoint.queryParameters) else {
            throw APIError.badURLEncoding
        }

        return URLRequest(url: url)
    }

    private func url(from path: String, queryParameters: [String: Any]?) -> URL? {
        guard var components = URLComponents(string: path) else {
            return nil
        }

        guard let queryParameters = queryParameters else {
            return components.url
        }

        components.queryItems = queryParameters
            .map({ (key, value) -> (String, String) in
                return (key, "\(value)")
            })
            .map { URLQueryItem(name: $0, value: $1) }

        return components.url
    }
}

