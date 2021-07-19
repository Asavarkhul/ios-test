//
//  DialogAlertPresenter.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import UIKit

/// A simple dialog presenter which takes a `DialogAlertDataSource`,
/// provides a way to listen to view dismissing state,
/// and the view on which to present the alert.
enum DialogPresenter {
    static func presentPopupDialog(
        dataSource: DialogAlertDataSource,
        onDismissAlertCompletion: (() -> Void)?,
        on presenter: UIViewController
    ) {
        let alert = UIAlertController(
            title: dataSource.message.localizedTitle,
            message: dataSource.message.localizedMessage,
            preferredStyle: .alert
        )

        if let cancelAction = dataSource.cancelAction {
            let cancelActionHandler: (UIAlertAction) -> Void = { _ in
                cancelAction()
            }
            let cancelAction = UIAlertAction(
                title: dataSource.message.localizedCancelActionTitle,
                style: .cancel,
                handler: cancelActionHandler
            )
            alert.addAction(cancelAction)
        }

        let alertActionHandler: (UIAlertAction) -> Void = { _ in
            dataSource.action()
        }
        let alertAction = UIAlertAction(
            title: dataSource.message.localizedCancelActionTitle,
            style: .default,
            handler: alertActionHandler
        )
        alert.addAction(alertAction)

        presenter.present(
            alert,
            animated: true,
            completion: onDismissAlertCompletion
        )
    }
}
