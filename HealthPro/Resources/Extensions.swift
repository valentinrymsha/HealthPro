//
//  Extensions.swift
//  HealthPro
//
//  Created by User on 9/7/22.
//

import UIKit

// MARK: UIImage

extension UIImage {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
          let size = image.size

          let widthRatio  = targetSize.width  / size.width
          let heightRatio = targetSize.height / size.height

          // Figure out what our orientation is, and use that to form the rectangle
          var newSize: CGSize
          if widthRatio > heightRatio {
              newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
          } else {
              newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
          }

          // This is the rect that we've calculated out and this is what is actually used below
          let rect = CGRect(origin: .zero, size: newSize)

          // Actually do the resizing to the rect using the ImageContext stuff
          UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
          image.draw(in: rect)
          let newImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()

          return newImage
      }
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
}
