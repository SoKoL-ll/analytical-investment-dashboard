//
//  UIColor+Ext.swift
//  AID
//
//  Created by Alexander on 22.03.2024.
//

import UIKit

extension UIColor {
    static let background: UIColor = {
        guard let color = UIColor(named: "Background") else {
            fatalError("Can't find color: Background")
        }
        
        return color
    }()
    
    static let backGroundPage: UIColor = {
        guard let color = UIColor(named: "BackgroundPage") else {
            fatalError("Can't find color: BackgroundPage")
        }

        return color
    }()

    static let accent: UIColor = {
        guard let color = UIColor(named: "Thistle") else {
            fatalError("Can't find color: Thistle")
        }
        
        return color
    }()
    
    static let positive: UIColor = {
        guard let color = UIColor(named: "Green") else {
            fatalError("Can't find color: Green")
        }
        return color
    }()
    
    static let neutral: UIColor = {
        guard let color = UIColor(named: "NeutralBubble") else {
            fatalError("Can't find color: Green")
        }
        return color
    }()

    static let negative: UIColor = {
        guard let color = UIColor(named: "Red") else {
            fatalError("Can't find color: Red")
        }
        return color
    }()
}
