//
//  HistoryCoordinator.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

final class HistoryCoordinator {
    
    // MARK: - Properties
    
    private let presenter: UIWindow
    private let navigationController: UINavigationController
    private let screens: Screens

    // MARK: - Init

    init(
        presenter: UIWindow,
        context: ContextType
    ) {
        self.presenter = presenter
        self.navigationController = UINavigationController(nibName: nil, bundle: nil)
        self.screens = Screens(context: context)
    }

    // MARK: - Coordinator

    func start() {
        presenter.rootViewController = navigationController
        showHistory()
    }

    private func showHistory() {
        let history = screens.createHistory(
            onSelectActivity: { [weak self] activity in
                self?.showDetails(for: activity)
            }
        )
        navigationController.viewControllers = [history]
    }

    private func showDetails(for activity: Activity) {
        let details = screens.createDetails(for: activity, onArchive: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })
        navigationController.pushViewController(details, animated: true)
    }
}
