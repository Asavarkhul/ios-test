//
//  JSONParser.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation
import RxSwift

protocol JSONParserType: AnyObject {
    func processCodableResponse<D: Decodable>(from data: Data) -> Observable<D>
}

final class JSONParser: JSONParserType {
    func processCodableResponse<D: Decodable>(from data: Data) -> Observable<D> {
        return Observable.create { observer in
            do {
                let object = try JSONDecoder().decode(D.self, from: data)
                observer.onNext(object)
                observer.onCompleted()
            } catch let error {
                observer.onError(APIError.invalidResponse("\(error)"))
            }

            return Disposables.create()
        }
    }
}
