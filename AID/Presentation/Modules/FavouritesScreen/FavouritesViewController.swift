//
//  FavouritesViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 21.03.2024.
//

import Foundation
import UIKit
import SwiftUI

protocol FavouritesViewControllerProtocol: AnyObject {
    func pushCompanyDetailsViewController(companyName: String)
    func setContent(pageInfo: PageInfo)
}

class FavouritesViewController: UIViewController {
    var presenter: FavouritesScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.launchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension FavouritesViewController: FavouritesViewControllerProtocol {
    func setContent(pageInfo: PageInfo) {
        let scrollView = PageViewBlank(
            pageInfo: pageInfo,
            isScrollViewEnable: true,
            delegate: self
        ) { [weak self] companyName in
            guard let self = self else {
                return
            }

            self.presenter?.openInfoAboutCompany(companyName: companyName)
        }

        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func pushCompanyDetailsViewController(companyName: String) {
        let controller = NavigationHostingController(
            rootView: DetailsView()
                .environmentObject(DetailsController(ticker: companyName))
        )
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension FavouritesViewController: ViewControllerDelegateFavourites {
    func deleteFromFavourites(companyName: String) -> Bool {
        presenter?.deleteFromFavourites(companyName: companyName)
        return true
    }
    
    func didCopmanyInFavourites(companyName: String) -> Bool {
        presenter?.companyInFavourites(companyName: companyName) ?? false
    }
}
