//
//  AppCoordinator.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

final class AppCoordinator {

    // MARK: - Private properties

    private unowned var appDelegate: AppDelegate
    private let context: ContextType
    private var historyCoordinator: HistoryCoordinator?

    // MARK: - Initializer

    init(
        appDelegate: AppDelegate,
        context: ContextType
    ) {
        self.appDelegate = appDelegate
        self.context = context
    }

    // MARK: - Coordinator

    func start() {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window!.rootViewController = UIViewController()
        appDelegate.window!.makeKeyAndVisible()

        showActivities()
    }

    private func showActivities() {
        historyCoordinator = HistoryCoordinator(
            presenter: appDelegate.window!,
            context: context
        )
        historyCoordinator?.start()
    }
}
