//
//  AlertMessage.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import Foundation

/// An informative message presented to the user.
/// Its content must be translated before presenting with use of `VPTranslator`.
public struct AlertMessage {
    /// Message title to be displayed.
    public let localizedTitle: String?

    /// Message body to be displayed.
    public let localizedMessage: String?

    /// Button title to be displayed for the action which cancels the operation and leaves things unchanged.
    /// For example: "OK".
    public let localizedCancelActionTitle: String?

    /// An optional button title to be displayed for the action which might apply the change to the operation.
    /// For example: "Try again".
    ///
    /// It is `nil` for informative messages.
    public let localizedActionTitle: String?

    /// An informative message presented to the user.
    /// Its content must be translated before presenting with use of `VPTranslator`.
    /// - Parameters:
    ///   - localizedTitle: Message title to be displayed.
    ///   - localizedMessage: Message body to be displayed.
    ///   - localizedCancelActionTitle: Button title to be displayed for the action which cancels the operation and leaves things unchanged.
    ///   - localizedActionTitle: An optional button title to be displayed for the action which might apply the change to the operation.
    public init(localizedTitle: String?, localizedMessage: String?, localizedCancelActionTitle: String?, localizedActionTitle: String? = nil) {
        self.localizedTitle = localizedTitle
        self.localizedMessage = localizedMessage
        self.localizedCancelActionTitle = localizedCancelActionTitle
        self.localizedActionTitle = localizedActionTitle
    }
}
