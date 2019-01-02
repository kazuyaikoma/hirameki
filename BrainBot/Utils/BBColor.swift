//
//  BBColor.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/03.
//  Copyright © 2019 kaz. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgbValue: UInt, alpha: CGFloat=1.0) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

/// BrainBot用
class BBColor {
    static let darkRed = UIColor(rgbValue: 0xB5555B)
    static let red = UIColor(rgbValue: 0xEB7470)
    static let yellow = UIColor(rgbValue: 0xF5CF09)
    static let blue = UIColor(rgbValue: 0x72CAC4)
    static let darkBlue = UIColor(rgbValue: 0x56636F)
}
