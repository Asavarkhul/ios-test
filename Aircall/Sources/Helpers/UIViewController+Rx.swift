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
    var viewWillAppear: Observable<Void> {
        base.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
    }
}
