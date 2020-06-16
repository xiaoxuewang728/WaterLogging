//
//  TrackWaterUnitView.swift
//  WaterLogging
//
//  Created by WangXiaoxue on 6/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class TrackWaterUnitView: UIView {
    private let headerLabel = UILabel()
    private let contentLabel = UILabel()
    init(header: String, content: String) {
        super.init(frame: CGRect.zero)
        headerLabel.text = header
        contentLabel.text = content
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)
        addSubview(contentLabel)

        headerLabel.font = UIFont.systemFont(ofSize: 20.0)
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        contentLabel.font = UIFont.systemFont(ofSize: 20.0)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center

        let headerLabelConstraints = [headerLabel.topAnchor.constraint(equalTo: self.topAnchor),
                                      headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                      headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)]

        NSLayoutConstraint.activate(headerLabelConstraints)

        let contentLabelConstraints = [contentLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
                                       contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                       contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                       contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)]

        NSLayoutConstraint.activate(contentLabelConstraints)
    }

    func updateContent(text: String) {
        contentLabel.text = text
    }
}

