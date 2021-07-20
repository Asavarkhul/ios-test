//
//  Screens.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

final class Screens {

    // MARK: - Properties

    private let context: ContextType
    
    // MARK: - Initializer

    init(context: ContextType) {
        self.context = context
    }
}

// MARK: - History
extension Screens {
    func createHistory(onSelectActivity: @escaping (Activity) -> Void) -> UIViewController {
        let repository: HistoryRepository = .live(
            requestBuilder: context.requestBuilder,
            client: context.client,
            parser: context.jsonParser
        )
        let viewModel = HistoryViewModel(
            repository: repository,
            actions: .init(
                onSelectActivity: onSelectActivity
            )
        )
        return HistoryViewController(viewModel: viewModel)
    }
}

// MARK: - Activity Details
extension Screens {
    func createDetails(for activity: Activity, onArchive: @escaping () -> Void) -> UIViewController {
        let repository: ActivityRepository = .live(
            requestBuilder: context.requestBuilder,
            client: context.client,
            parser: context.jsonParser
        )
        let viewModel = ActivityViewModel(
            activity: activity,
            actions: .init(onArchive: onArchive),
            repository: repository
        )
        return ActivityDetailsViewController(viewModel: viewModel)
    }
}
