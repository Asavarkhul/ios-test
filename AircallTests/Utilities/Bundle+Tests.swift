//
//  Bundle+Tests.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import Foundation

public extension Bundle {

    /// Returns the bundle for itself.
    class var test: Bundle {
        Bundle(for: BundleFinder.self)
    }
}

private class BundleFinder {}
