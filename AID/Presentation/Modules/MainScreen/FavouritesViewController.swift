//
//  FavouritesViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 21.03.2024.
//

import Foundation
import UIKit

class FavouritesViewController: UIViewController {
    private lazy var todoLabel: UILabel = {
        let label = UILabel()
        label.text = "UPCOMING"
        label.font = UIFont.systemFont(ofSize: 36)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3
        view.addSubview(todoLabel)

        todoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
