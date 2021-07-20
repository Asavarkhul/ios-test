//
//  HistoryViewController.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HistoryViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: HistoryViewModel
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        tableView.register(
            ActivityTableViewCell.self,
            forCellReuseIdentifier: ActivityTableViewCell.defaultReuseIdentifier
        )
        return tableView
    }()
    private lazy var resetBarButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem()
        buttonItem.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        buttonItem.style = .plain
        return buttonItem
    }()
    private lazy var activityLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .medium
        loader.hidesWhenStopped = true
        return loader
    }()
    private var dataSource: [HistoryItems] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Rx

    private let onPressItemAtIndexSubject = PublishSubject<Int>()
    private let onArchiveActivityAtIndex = PublishSubject<(index: Int, completionHandler: (Bool) -> Void)>()
    private let disposeBag = DisposeBag()

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
        setupLayout()
        setupView()
        bindViewModel()
    }

    private func setupLayout() {
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = resetBarButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityLoader)

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
        resetBarButtonItem.tintColor = #colorLiteral(red: 0.04121053964, green: 0.6986636519, blue: 0.5262304544, alpha: 1)
        activityLoader.color = #colorLiteral(red: 0.04121053964, green: 0.6986636519, blue: 0.5262304544, alpha: 1)
    }

    private func bindViewModel() {
        let startTrigger = rx
            .viewWillAppear
            .mapToVoid()

        let inputs = HistoryViewModel.Inputs(
            startTrigger: startTrigger,
            didPressActivityAtIndex: onPressItemAtIndexSubject,
            didArchiveActivtyAtIndex: onArchiveActivityAtIndex,
            didPressReset: resetBarButtonItem.rx.tap.asObservable()
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

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard dataSource.indices.contains(indexPath.item) else {
            return UITableViewCell() // We should monitor this ☝️ ex: `return monitoring.nonFatalError()`
        }
        let item = dataSource[indexPath.item]
        switch item {
        case .activity(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ActivityTableViewCell.defaultReuseIdentifier, for: indexPath
            ) as? ActivityTableViewCell else {
                return UITableViewCell() // We should monitor this ☝️ ex: `return monitoring.nonFatalError()`
            }
            cell.configure(with: viewModel)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onPressItemAtIndexSubject.onNext(indexPath.item)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "", handler: { _, _, completionHandler in
            self.onArchiveActivityAtIndex.onNext((index: indexPath.item, completionHandler: completionHandler))
        })
        action.image = UIImage(systemName: "archivebox")
        action.backgroundColor = #colorLiteral(red: 0.04121053964, green: 0.6986636519, blue: 0.5262304544, alpha: 1)
        return UISwipeActionsConfiguration(actions: [action])
    }
}
