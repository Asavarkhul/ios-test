//
//  ActivitiesCoordinator.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

final class ActivitiesCoordinator {
    
    // MARK: - Properties
    
    private let presenter: UIWindow
    private let navigationController: UINavigationController
    private let screens: Screens

    // MARK: - Init

    init(
        presenter: UIWindow,
        context: Context
    ) {
        self.presenter = presenter
        self.navigationController = UINavigationController(nibName: nil, bundle: nil)
        self.screens = Screens(context: context)
    }

    // MARK: - Coordinator

    func start() {
        presenter.rootViewController = navigationController
        showArticles()
    }

    private func showArticles() {
        
        
    }

    private func showFavorites() {
        
    }
}
