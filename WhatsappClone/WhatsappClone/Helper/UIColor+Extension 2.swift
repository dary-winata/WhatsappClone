//
//  UIColor+Extension.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 22/08/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(redMax: Int, greenMax: Int, blueMax: Int, alphaMax: CGFloat) {
        let red: CGFloat = CGFloat(redMax)/255
        let green: CGFloat = CGFloat(greenMax)/255
        let blue: CGFloat = CGFloat(blueMax)/255
        self.init(red: red, green: green, blue: blue, alpha: alphaMax)
    }
}
