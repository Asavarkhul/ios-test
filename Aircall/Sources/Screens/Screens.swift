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

// MARK: - Activities
extension Screens {
    func createActivities() -> UIViewController {
        return UIViewController()
    }
}

// MARK: - Activity Details
extension Screens {
    func createActivityDetails(for id: String) -> UIViewController {
        return UIViewController()
    }
}
