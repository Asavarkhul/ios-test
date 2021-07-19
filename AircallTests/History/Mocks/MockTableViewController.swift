//
//  MockTableViewController.swift
//  AircallTests
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import UIKit

class MockTableViewController: UITableViewController {
    var cells: [UITableViewCell] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        cells.count
    }

    override public func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override public func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cells[indexPath.row]
    }
}

