//
//  AppDelegate.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?
    private var context: Context!
    private var coordinator: AppCoordinator!

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        context = Context.build()
        coordinator = AppCoordinator(
            appDelegate: self,
            context: context
        )
        coordinator.start()
        return true
    }
}
