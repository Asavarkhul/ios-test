//
//  NetworkTableViewCell.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import UIKit
import SnapKit

final class NetworkTableViewCell: UITableViewCell {

    // MARK: - Main
    private let mainContainer = UIStackView(
        distribution: .fill,
        alignment: .leading,
        axis: .vertical,
        spacing: 8
    )

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()

    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: - Configure

    func configure(with viewModel: NetworkViewModel) {
        titleLabel.text = viewModel.titleText
        subTitleLabel.text = viewModel.subTitleText
    }
}

private extension NetworkTableViewCell {
    func setupUI() {
        setupLayout()
        setupView()
    }

    func setupLayout() {
        selectionStyle = .none

        // MARK: - Main
        contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(44)
            $0.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(contentView).inset(8)
            $0.bottom.equalTo(contentView).inset(8)
        }

        mainContainer.addArrangedSubviews([
            titleLabel,
            subTitleLabel
        ])
    }

    func setupView() {
        titleLabel.textColor = #colorLiteral(red: 0.06150835007, green: 0.09044837207, blue: 0.1245655492, alpha: 1)
        subTitleLabel.textColor = #colorLiteral(red: 0.4311936498, green: 0.4554408789, blue: 0.4724093676, alpha: 1)
    }
}
