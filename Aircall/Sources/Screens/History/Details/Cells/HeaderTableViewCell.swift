//
//  HeaderTableViewCell.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import UIKit
import SnapKit

final class HeaderTableViewCell: UITableViewCell {

    // MARK: - Main
    private let mainContainer = UIStackView(
        distribution: .fill,
        alignment: .leading,
        axis: .horizontal,
        spacing: 8
    )
    private let titleLabel = UILabel()

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

    func configure(with title: String) {
        titleLabel.text = title
    }
}

private extension HeaderTableViewCell {
    private func setupUI() {
        setupLayout()
        setupView()
    }

    private func setupLayout() {
        selectionStyle = .none

        // MARK: - Main
        contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(16)
            $0.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(contentView).inset(8)
            $0.bottom.equalTo(contentView).inset(8)
        }

        mainContainer.addArrangedSubviews([
            titleLabel
        ])
    }

    private func setupView() {
        contentView.backgroundColor = #colorLiteral(red: 0.9841676354, green: 0.9844350219, blue: 0.9798845649, alpha: 1)
        titleLabel.textColor = #colorLiteral(red: 0.06150835007, green: 0.09044837207, blue: 0.1245655492, alpha: 1)
    }
}
