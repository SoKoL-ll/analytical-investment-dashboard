//
//  BubbleView.swift
//  AID
//
//  Created by Alexandr Sokolov on 20.03.2024.
//

import Foundation
import UIKit

final class BubbleView: UIView {
    private lazy var labelOfName: UILabel = {
        let label = UILabel()

        return label
    }()

    private lazy var someStatisticLabel: UILabel = {
        let label = UILabel()
        label.text = "+228%"
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()

    init(companyName: String) {
        super.init(frame: .zero)
        setupLabels(companyName: companyName)
    }
    
    private func setupLabels(companyName: String) {
        labelOfName.text = companyName

        self.addSubview(labelOfName)
        self.addSubview(someStatisticLabel)

        labelOfName.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        someStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(labelOfName.snp_bottomMargin).offset(6)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
