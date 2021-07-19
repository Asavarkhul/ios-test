//
//  ActivityCellViewModel.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import Foundation

struct ActivityCellViewModel {

    // MARK: - Outputs

    let titleText: String
    let subTitleText: String
    let dayText: String
    let hourText: String
    let directionImageName: String
    let callState: CallState
    let infoImageViewName: String

    enum CallState {
        case missed
        case voicemail
        case answered
    }
}

extension ActivityCellViewModel {
    init(activity: Activity) {
        if case .inbound = activity.direction {
            titleText = activity.from
            directionImageName = Constants.phoneArrowDownLeft
            subTitleText = Current.translator.translationByReplacingVariables(
                for: Constants.inBoundViaText,
                var: activity.via
            )
        } else {
            titleText = activity.to ?? "☠️"
            directionImageName = Constants.phoneArrowUpRight
            subTitleText = Current.translator.translationByReplacingVariables(
                for: Constants.outBoundViaText,
                var: activity.via
            )
        }

        dayText = Constants.dayFormat(date: activity.createdAt) ?? "☠️"
        hourText = Constants.hourFormat(date: activity.createdAt) ?? "☠️"
        infoImageViewName = Constants.exclamationMarkCircle
        callState = .init(callType: activity.callType)
    }
}

extension ActivityCellViewModel {
    enum Constants {
        static var phoneArrowDownLeft: String { "phone.arrow.down.left" }
        static var phoneArrowUpRight: String { "phone.arrow.up.right" }
        static var exclamationMarkCircle: String { "info.circle" }
        static var inBoundViaText: String { "mobile/history/activity-inboud-via.text" }
        static var outBoundViaText: String { "mobile/history/activity-outbound-via.text" }

        static func dayFormat(date: String) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Current.locale()
            dateFormatter.dateFormat = "MMM. dd"
            guard let formattedDate = Date.getDate(from: date) else {
                assertionFailure() // We should monitor this ☝️
                return nil
            }
            return dateFormatter.string(from: formattedDate)
        }

        static func hourFormat(date: String) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Current.locale()
            dateFormatter.dateFormat = "HH:mm"
            guard let formattedDate = Date.getDate(from: date) else {
                assertionFailure() // We should monitor this ☝️
                return nil
            }
            return dateFormatter.string(from: formattedDate)
        }
    }
}

private extension ActivityCellViewModel.CallState {
    init(callType: Activity.CallType) {
        switch callType {
        case .answered: self = .answered
        case .missed: self = .missed
        case .voicemail: self = .voicemail
        }
    }
}
