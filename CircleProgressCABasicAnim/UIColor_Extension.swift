//
//  UIColor_Extension.swift
//  CircleProgressCABasicAnim
//
//  Created by David on 14/12/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)

    
}
