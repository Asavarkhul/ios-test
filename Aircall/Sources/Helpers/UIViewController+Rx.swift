//
//  UIViewController+Rx.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewIsLoaded: Observable<Void> {
        base.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in }.take(1)
    }
}
