//
//  NetworkViewModel.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import Foundation

struct NetworkViewModel {

    // MARK: - Outputs

    let titleText: String
    let subTitleText: String
}

extension NetworkViewModel {
    init(activity: Activity) {
        self.titleText = activity.via
        if case .inbound = activity.direction {
            self.subTitleText = activity.from
        } else {
            self.subTitleText = activity.to ?? "☠️"
        }
    }
}
