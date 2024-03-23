//
//  BubbleView.swift
//  AID
//
//  Created by Alexandr Sokolov on 20.03.2024.
//

import Foundation
import UIKit

final class BubbleView: UIView {

    private var editMenuInteraction: UIContextMenuInteraction?
    private let bubbleDidTap: (String) -> Void

    // Label названия компании
    private lazy var labelOfName: UILabel = {
        let label = UILabel()

        return label
    }()

    // Label для выбранной информации
    private lazy var someStatisticLabel: UILabel = {
        let label = UILabel()

        label.text = "+228%"
        label.font = UIFont.systemFont(ofSize: 11)

        return label
    }()

    init(companyName: String, bubbleDidTap: @escaping (String) -> Void) {
        self.bubbleDidTap = bubbleDidTap

        super.init(frame: .zero)

        setupView()
        setupLabels(companyName: companyName)
        self.editMenuInteraction = UIContextMenuInteraction(delegate: self)

        self.addInteraction(editMenuInteraction!)
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.addGestureRecognizer(tapGesture)
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

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard sender.view is BubbleView else {
            return
        }

        bubbleDidTap(self.labelOfName.text ?? "")
    }
}

extension BubbleView: UIContextMenuInteractionDelegate {

    // Конфигурация контекстного меню. Пока что тут просто данные для примера
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            return UIMenu(title: "", children: [
                UIAction(title: "Item 1", image: UIImage(systemName: "mic"), handler: { _ in }),
                UIAction(title: "Item 2", image: UIImage(systemName: "message"), handler: { _ in }),
                UIMenu(title: "", options: .displayInline, children: [
                    UIAction(title: "Item 3", image: UIImage(systemName: "envelope"), handler: { _ in }),
                    UIAction(title: "Item 4", image: UIImage(systemName: "phone"), handler: { _ in }),
                    UIAction(title: "Item 5", image: UIImage(systemName: "video"), handler: { _ in })
                ])
            ])
        }
    }
}
