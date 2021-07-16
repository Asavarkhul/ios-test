//
//  ObservableType+Extension.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import RxCocoa
import RxSwift
import RxSwiftExt

public extension ObservableType {
    /// Converts observable sequence to Driver trait and
    /// returns an empty observable sequence, using the specified scheduler to send out the single Completed message.
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in
            Driver.empty()
        }
    }

    /// Projects each element of an observable sequence into Void.
    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }

    /// Safe request handler. It emits true and false on the loadingSubject and every error is filtered.
    ///
    /// - Parameter request: Request.
    /// - Parameter onLoading: Emit true when the request starts and false when the request has completed/failed.
    /// - Parameter onError: Errors behaviour will be handled here.
    func performRequest<T, ErrorType>(
        _ request: @escaping (Element) -> Single<Swift.Result<T, ErrorType>>,
        onLoading: ((Bool) -> Void)?,
        onError: ((_ errorType: ErrorType) -> Void)?
    ) -> Observable<T> {
        return flatMapLatest { value -> Observable<T> in
            let startSubject = PublishSubject<Void>()
            return startSubject
                .startWith(())
                .handleLoading(
                    request: { request(value) },
                    onLoading: onLoading
                )
                .map { $0 }
                .filterError(onError: onError)
        }
    }

    private func handleLoading<T>(
        request: @escaping (Element) -> Single<T>,
        onLoading: ((Bool) -> Void)?
    ) -> Observable<T> {
        flatMapLatest { value -> Single<T> in
            onLoading?(true)
            return request(value)
        }
        .do(onNext: { _ in
            onLoading?(false)
        }, onError: { _ in
            onLoading?(false)
        })
    }

    private func filterError<T, ErrorType>(
        onError: ((ErrorType) -> Void)?
    ) -> Observable<T> where Element == Swift.Result<T, ErrorType> {
        return filterMap ({
            switch $0 {
            case .success(let value):
                return .map(value)
            case .failure(let error):
                onError?(error)
                return .ignore
            }
        })
    }
}
