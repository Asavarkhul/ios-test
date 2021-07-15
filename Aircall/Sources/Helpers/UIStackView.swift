//
//  UIStackView.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 15/07/2021.
//

import UIKit

public extension UIStackView {
    convenience init(
        views: [UIView] = [],
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0
    ) {
        self.init(arrangedSubviews: views)
        self.distribution = distribution
        self.alignment = alignment
        self.axis = axis
        self.spacing = spacing
    }

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
