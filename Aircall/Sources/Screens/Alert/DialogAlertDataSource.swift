//
//  DialogAlertDataSource.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import Foundation

/// A simple structure to handle both `AlertMessage` and alert actions.
struct DialogAlertDataSource {
    let message: AlertMessage
    let action: () -> Void
    let cancelAction: (() -> Void)?

    init(
        message: AlertMessage,
        action: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.action = action
        self.cancelAction = cancelAction
    }
}
