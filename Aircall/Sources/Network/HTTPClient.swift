//
//  HTTPClient.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

protocol HTTPClientType: AnyObject {
    func send(request: URLRequest) -> Observable<Data>
}

final class HTTPClient: HTTPClientType {

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Init

    init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }

    func send(request: URLRequest) -> Observable<Data> {
        return Observable.create { observer in
            let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
                guard
                    response != nil,
                    let response = response as? HTTPURLResponse,
                    Array(200..<300).contains(response.statusCode)
                else {
                    observer.onError(APIError.networkProblem)
                    return
                }

                guard let data = data, !data.isEmpty else {
                    observer.onError(APIError.noData)
                    return
                }

                observer.onNext(data)
                observer.onCompleted()
            })

            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

