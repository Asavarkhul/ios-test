//
//  CallViewModel.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import Foundation

struct CallViewModel {

    // MARK: - Outputs

    let titleText: String
    let directionImageName: String
    let callState: CallState

    enum CallState: String {
        case missed
        case voicemail
        case answered
    }
}

extension CallViewModel {
    init(activity: Activity) {
        callState = .init(callType: activity.callType)
        if case .inbound = activity.direction {
            directionImageName = Constants.phoneArrowDownLeft
            titleText = Current.translator.translationByReplacingVariables(
                for: Constants.incomingCallText,
                var: callState.description
            )
        } else {
            directionImageName = Constants.phoneArrowUpRight
            titleText = Current.translator.translationByReplacingVariables(
                for: Constants.outgoingCallText,
                var: callState.description
            )
        }
    }
}

extension CallViewModel {
    enum Constants {
        static var phoneArrowDownLeft: String { "phone.arrow.down.left" }
        static var phoneArrowUpRight: String { "phone.arrow.up.right" }
        static var incomingCallText: String { "mobile/activity/details/incoming-call.text" }
        static var outgoingCallText: String { "mobile/activity/details/outgoing-call.text" }
    }
}

private extension CallViewModel.CallState {
    init(callType: Activity.CallType) {
        switch callType {
        case .answered: self = .answered
        case .missed: self = .missed
        case .voicemail: self = .voicemail
        }
    }

    var description: String {
        switch self {
        case .answered:
            return Current.translator.translation(for: "mobile/activity/answered-call-text")
        case .missed:
            return Current.translator.translation(for: "mobile/activity/missed-call.text")
        case .voicemail:
            return Current.translator.translation(for: "mobile/activity/voicemail-call.text")
        }
    }
}
