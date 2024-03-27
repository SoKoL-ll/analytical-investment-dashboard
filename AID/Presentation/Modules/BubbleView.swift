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
    weak var delegate: ViewControllerDelegateFavourites?

    // Label названия компании
    private lazy var labelOfName: UILabel = {
        let label = UILabel()

        return label
    }()

    // Label для выбранной информации
    private lazy var someStatisticLabel: UILabel = {
        let label = UILabel()

        label.text = "+228%"
        label.font = UIFont.systemFont(ofSize: Constants.fontSizeLabelStatistic)

        return label
    }()

    init(companyName: String, delegate: ViewControllerDelegateFavourites?, bubbleDidTap: @escaping (String) -> Void) {
        self.delegate = delegate
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

        let maxSize: CGFloat = Constants.defaultBubbleSize + CGFloat.random(in: (0 ... 50))
        let sizeOfView = UIScreen.main.bounds

        let x = CGFloat.random(in: (sizeOfView.origin.x + Margins.small ...
                                    (sizeOfView.origin.x + sizeOfView.width - maxSize - Constants.largeMargin - Margins.small)))
        let y: CGFloat = CGFloat.random(
            in: (sizeOfView.origin.y + Margins.small ... (sizeOfView.origin.y + sizeOfView.height - maxSize - Constants.largeMargin - Margins.big))
        )
        let origin: CGPoint = CGPoint(x: x, y: y)

        self.backgroundColor = maxSize > 70 ? .positive : .negative
        self.frame = CGRect(origin: origin, size: CGSize(width: maxSize, height: maxSize))
        self.layer.cornerRadius = self.frame.width / 2
    }

    private func setupLabels(companyName: String) {
        labelOfName.text = companyName

        self.addSubview(labelOfName)
        self.addSubview(someStatisticLabel)

        labelOfName.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        someStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(labelOfName.snp_bottomMargin).offset(Constants.smallMargin)
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
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ -> UIMenu? in
            guard let self = self else {
                return nil
            }

            if delegate?.didCopmanyInFavourites(companyName: self.labelOfName.text ?? "") ?? false {
                return UIMenu(title: "", children: [
                    UIAction(title: "Удалить из избранного", image: UIImage(systemName: "star"), handler: { [weak self] _ in
                        guard let self = self else {
                            return
                        }

                        if self.delegate?.deleteFromFavourites(companyName: self.labelOfName.text ?? "") ?? false {
                            UIView.animate(withDuration: Constants.animateDuration) {
                                self.isHidden = true
                            }
                        }
                    }
                            )
                ])
            } else {
                return UIMenu(title: "", children: [
                    UIAction(title: "Добавить в избранное", image: UIImage(systemName: "star.fill"), handler: { [weak self] _ in
                        guard let self = self else {
                            return
                        }

                        self.delegate?.addToFavourites(companyName: self.labelOfName.text ?? "")
                    }
                            )
                ])
            }
        }
    }
}

private extension BubbleView {
    struct Margins {
        static let big: CGFloat = 200
        static let small: CGFloat = 50
        static let medium: CGFloat = 100
    }
}
