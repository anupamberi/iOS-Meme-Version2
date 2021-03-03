//
//  ImageUtil.swift
//  iOS-Meme-Version2
//
//  Created by Anupam Beri on 03/03/2021.
//

import Foundation
import UIKit

// MARK : A utility class that offers image manipulation utilities
class ImageUtil: NSObject {
    
    // MARK : Crops a given image into a square. This is useful for a thumbnail display in views.
    // Function done in an attempt to remove the black bars from images so that thumbnails in views
    // are more to scale.
    // Reference : https://stackoverflow.com/questions/32041420/cropping-image-with-swift-and-put-it-on-center-position
    
    static func crop(image: UIImage) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if (contextSize.width > contextSize.height) {
            posY = 0
            posX = ((contextSize.width - contextSize.height) / 2)
            newWidth = contextSize.height
            newHeight = contextSize.height
        } else {
            posY = ((contextSize.height - contextSize.width) / 2)
            posX = 0
            newWidth = contextSize.width
            newHeight = contextSize.width
        }
        
        let croppingRectangle: CGRect = CGRect(x: posX, y: posY, width: newWidth, height: newHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = (contextImage.cgImage?.cropping(to: croppingRectangle))!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return croppedImage
    }
}
