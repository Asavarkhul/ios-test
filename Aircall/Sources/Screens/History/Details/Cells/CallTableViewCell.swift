//
//  CallTableViewCell.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 20/07/2021.
//

import UIKit
import SnapKit

final class CallTableViewCell: UITableViewCell {

    // MARK: - Main
    private let mainContainer = UIStackView(
        distribution: .fill,
        alignment: .leading,
        axis: .horizontal,
        spacing: 8
    )

    private let directionImageView = UIImageView()
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

    func configure(with viewModel: CallViewModel) {
        directionImageView.image = UIImage(
            systemName: viewModel.directionImageName
        )

        switch viewModel.callState {
        case .answered:
            directionImageView.tintColor = #colorLiteral(red: 0.04121053964, green: 0.6986636519, blue: 0.5262304544, alpha: 1)
        case .missed:
            directionImageView.tintColor = #colorLiteral(red: 0.9987418056, green: 0.361864388, blue: 0.2207925916, alpha: 1)
        case .voicemail:
            directionImageView.tintColor = #colorLiteral(red: 0.4311936498, green: 0.4554408789, blue: 0.4724093676, alpha: 1)
        }

        titleLabel.text = viewModel.titleText
    }
}

private extension CallTableViewCell {
    func setupUI() {
        setupLayout()
        setupView()
    }

    func setupLayout() {
        selectionStyle = .none

        // MARK: - Main
        contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(16)
            $0.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(contentView).inset(8)
            $0.bottom.equalTo(contentView).inset(8)
        }

        directionImageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }

        mainContainer.addArrangedSubviews([
            directionImageView,
            titleLabel
        ])
    }

    func setupView() {
        titleLabel.textColor = #colorLiteral(red: 0.06150835007, green: 0.09044837207, blue: 0.1245655492, alpha: 1)
    }
}
