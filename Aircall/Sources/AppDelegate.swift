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
    private var context: ContextType!
    private var coordinator: AppCoordinator!

    // MARK: - UIApplicationDelegate

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if ProcessInfo.processInfo.environment["IS_RUNNING_UNIT_TESTS"] == "YES" {
            // We don't want to load the app while under unit tests.
            return true
        }

        configureTranslator()
        context = Context.build()
        coordinator = AppCoordinator(
            appDelegate: self,
            context: context
        )
        coordinator.start()
        return true
    }

    private func configureTranslator() {
        do {
            try Translator.configure(for: "Localizable", in: .main)
        } catch {
            assertionFailure("We should monitor this 🕵️")
        }
    }
}
