//
//  ActivityTableViewCell.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 16/07/2021.
//

import UIKit
import SnapKit

final class ActivityTableViewCell: UITableViewCell {

    // MARK: - Main
    private let mainContainer = UIStackView(
        distribution: .fill,
        alignment: .center,
        axis: .horizontal,
        spacing: 8
    )

    // MARK: - Left Container
    private let leftContainer = UIStackView(
        distribution: .fill,
        alignment: .center,
        axis: .horizontal,
        spacing: 16
    )
    private let directionImageView = UIImageView()
    private let titlesContainer = UIStackView(
        distribution: .fill,
        alignment: .leading,
        axis: .vertical,
        spacing: 4
    )
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    // MARK: - Right Container
    private let rightContainer = UIStackView(
        distribution: .fill,
        alignment: .center,
        axis: .horizontal,
        spacing: 16
    )
    private let timeContainer = UIStackView(
        distribution: .fill,
        alignment: .trailing,
        axis: .vertical,
        spacing: 4
    )
    private let dayLabel = UILabel()
    private let hourLabel = UILabel()
    private let infoImageView = UIImageView()

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

    func configure(with viewModel: ActivityCellViewModel) {
        directionImageView.image = UIImage(
            systemName: viewModel.directionImageName
        )

        infoImageView.image = UIImage(
            systemName: viewModel.infoImageViewName
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
        subTitleLabel.text = viewModel.subTitleText
        dayLabel.text = viewModel.dayText
        hourLabel.text = viewModel.hourText
    }
}

private extension ActivityTableViewCell {
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

        titlesContainer.addArrangedSubviews([
            titleLabel,
            subTitleLabel
        ])

        leftContainer.addArrangedSubviews([
            directionImageView,
            titlesContainer
        ])

        timeContainer.addArrangedSubviews([
            dayLabel,
            hourLabel
        ])

        rightContainer.addArrangedSubviews([
            timeContainer,
            infoImageView
        ])

        mainContainer.addArrangedSubviews([
            leftContainer,
            rightContainer
        ])
    }

    func setupView() {
        titleLabel.textColor = #colorLiteral(red: 0.06150835007, green: 0.09044837207, blue: 0.1245655492, alpha: 1)
        subTitleLabel.textColor = #colorLiteral(red: 0.4311936498, green: 0.4554408789, blue: 0.4724093676, alpha: 1)
        dayLabel.textColor = #colorLiteral(red: 0.4311936498, green: 0.4554408789, blue: 0.4724093676, alpha: 1)
        hourLabel.textColor = #colorLiteral(red: 0.4311936498, green: 0.4554408789, blue: 0.4724093676, alpha: 1)
        infoImageView.tintColor = #colorLiteral(red: 0.4311936498, green: 0.4554408789, blue: 0.4724093676, alpha: 1)
    }
}
