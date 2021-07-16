//
//  Screens.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

final class Screens {

    // MARK: - Properties

    private let context: Context
    
    // MARK: - Initializer

    init(context: Context) {
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
    func createDetails(for activity: Activity) -> UIViewController {
        return UIViewController()
    }
}
