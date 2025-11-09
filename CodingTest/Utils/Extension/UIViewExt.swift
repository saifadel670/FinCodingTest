//
//  UIViewExt.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

extension UIView {
    func roundedCorners(corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}
