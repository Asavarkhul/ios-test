//
//  HistoryViewController.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

final class HistoryViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: HistoryViewModel

    // MARK: - Init

    init(
        viewModel: HistoryViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
