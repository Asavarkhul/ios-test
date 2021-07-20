//
//  ActivityDetailsViewController.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ActivityDetailsViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ActivityViewModel
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        tableView.register(
            HeaderTableViewCell.self,
            forCellReuseIdentifier: HeaderTableViewCell.defaultReuseIdentifier
        )
        tableView.register(
            CallTableViewCell.self,
            forCellReuseIdentifier: CallTableViewCell.defaultReuseIdentifier
        )
        tableView.register(
            NetworkTableViewCell.self,
            forCellReuseIdentifier: NetworkTableViewCell.defaultReuseIdentifier
        )
        return tableView
    }()
    private lazy var archiveBarButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem()
        buttonItem.image = UIImage(systemName: "archivebox")
        buttonItem.style = .plain
        return buttonItem
    }()
    private lazy var activityLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .medium
        loader.hidesWhenStopped = true
        return loader
    }()
    private var dataSource: [ActivityViewModel.DisplayedActivityItems] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Rx

    private let disposeBag = DisposeBag()

    // MARK: - Init

    init(
        viewModel: ActivityViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupView()
        bindViewModel()
    }

    private func setupLayout() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.04121053964, green: 0.6986636519, blue: 0.5262304544, alpha: 1)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [
            archiveBarButtonItem,
            UIBarButtonItem(customView: activityLoader)
        ]

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.top.equalTo(view)
            $0.bottom.equalTo(view)
        }
    }

    private func setupView() {
        archiveBarButtonItem.tintColor = #colorLiteral(red: 0.04121053964, green: 0.6986636519, blue: 0.5262304544, alpha: 1)
        activityLoader.color = #colorLiteral(red: 0.04121053964, green: 0.6986636519, blue: 0.5262304544, alpha: 1)
    }

    private func bindViewModel() {
        let startTrigger = rx
            .viewWillAppear
            .mapToVoid()

        let inputs = ActivityViewModel.Inputs(
            startTrigger: startTrigger,
            didPressArchive: archiveBarButtonItem.rx.tap.asObservable()
        )

        let outputs = viewModel.transform(inputs: inputs)

        outputs
            .title
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] title in
                self?.title = title
            })
            .disposed(by: disposeBag)

        outputs
            .items
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] items in
                self?.dataSource = items
            })
            .disposed(by: disposeBag)

        outputs
            .alertDataSource
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] dataSource in
                self?.displayAlert(dataSource: dataSource)
            })
            .disposed(by: disposeBag)

        outputs
            .isLoading
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] state in
                switch state {
                case true:
                    self?.activityLoader.startAnimating()
                case false:
                    self?.activityLoader.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        outputs
            .actions
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
    }

    // MARK: - Alert

    private func displayAlert(dataSource: DialogAlertDataSource) {
        DialogPresenter.presentPopupDialog(
            dataSource: dataSource,
            onDismissAlertCompletion: nil,
            on: self
        )
    }
}

extension ActivityDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard dataSource.indices.contains(indexPath.item) else {
            return UITableViewCell() // We should monitor this ☝️ ex: `return monitoring.nonFatalError()`
        }
        let item = dataSource[indexPath.item]
        switch item {
        case .header(let title):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HeaderTableViewCell.defaultReuseIdentifier, for: indexPath
            ) as? HeaderTableViewCell else {
                return UITableViewCell() // We should monitor this ☝️ ex: `return monitoring.nonFatalError()`
            }
            cell.configure(with: title)
            return cell
        case .call(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CallTableViewCell.defaultReuseIdentifier, for: indexPath
            ) as? CallTableViewCell else {
                return UITableViewCell() // We should monitor this ☝️ ex: `return monitoring.nonFatalError()`
            }
            cell.configure(with: viewModel)
            return cell
        case .network(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NetworkTableViewCell.defaultReuseIdentifier, for: indexPath
            ) as? NetworkTableViewCell else {
                return UITableViewCell() // We should monitor this ☝️ ex: `return monitoring.nonFatalError()`
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
}
