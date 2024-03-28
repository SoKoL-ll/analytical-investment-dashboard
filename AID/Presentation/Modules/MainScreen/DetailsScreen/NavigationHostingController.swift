//
//  NavigationHostingController.swift
//  AID
//
//  Created by Михаил Симаков on 28.03.2024.
//

import Foundation
import SwiftUI
import UIKit

class NavigationHostingController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
