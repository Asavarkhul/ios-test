//
//  XCTestCase+Extensions.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import XCTest
import UIKit
import SnapshotTesting

public extension XCTestCase {
    func snapshotCell(_ cell: UITableViewCell, testName: String = #function, file: StaticString = #file, line: UInt = #line) {
        let viewController = MockTableViewController()
        viewController.view.frame = UIScreen.main.bounds
        viewController.tableView.separatorStyle = .none
        viewController.cells = [cell]
        let indexPath = IndexPath(row: 0, section: 0)
        assertSnapshot(matching: viewController.tableView.cellForRow(at: indexPath)!, as: .image, file: file, testName: testName, line: line)
    }
}

