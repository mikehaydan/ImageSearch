//
//  CropService.swift
//  ImageSearch
//
//  Created by Mike Haydan on 09/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

final class CropSerivce {
    func cropTo(image: UIImage, to size: CGSize) -> UIImage {
        let widthFactor = size.width / image.size.width
        let heightFactor = size.height / image.size.height
        
        let scaledFactor: CGFloat
        if widthFactor > heightFactor {
            scaledFactor = widthFactor
        } else {
            scaledFactor = heightFactor
        }
        
        let scaledWidth = image.size.width * scaledFactor
        let scaledHeight = image.size.height * scaledFactor
        
        var point = CGPoint.zero
        if widthFactor > heightFactor {
            point.y = (size.height - scaledHeight) * 0.5
        } else {
            point.x = (size.width - scaledWidth) * 0.5
        }
        
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: point.x, y: point.y, width: scaledWidth, height: scaledHeight))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage ?? image
        
    }
}
