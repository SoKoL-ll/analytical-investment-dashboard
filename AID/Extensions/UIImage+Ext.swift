//
//  UIImage+Ext.swift
//  AID
//
//  Created by Egor Anoshin on 28.03.2024.
//

import Foundation
import SwiftUI

extension UIImage {
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
    
    static func saveImage(_ image: UIImage, name: String = "savedProfileImage.jpg") {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            try? data.write(to: directory.appendingPathComponent(name))
        }
    }
    
    static func loadImage(name: String = "savedProfileImage.jpg") -> UIImage? {
        if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
           let image = UIImage(contentsOfFile: directory.appendingPathComponent(name).path) {
            return image
        }
        return nil
    }
}
