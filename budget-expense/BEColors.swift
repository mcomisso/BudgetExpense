//
//  BEColors.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit

// Generate Colors slghtly darker and lighter

// Generate oblique color

final class BEColorGenerator {


    /// Generate a map of colors, from the basecolor (middle), returning a tuple of a slightly lighter and slightly darker
    ///
    /// - Parameter color: The color in input
    /// - Returns: Returns a tuple as (lighter, standard, darker) colors.
    static func generateMapOfColors(from color: UIColor) -> (UIColor, UIColor, UIColor) {

        var huecomponents = (0 as CGFloat, 0 as CGFloat, 0 as CGFloat, 0 as CGFloat)
        color.getHue(&huecomponents.0, saturation: &huecomponents.1, brightness: &huecomponents.2, alpha: &huecomponents.3)

//        var components = (0 as CGFloat, 0 as CGFloat, 0 as CGFloat, 0 as CGFloat)
//        color.getRed(&components.0, green: &components.1, blue: &components.2, alpha: &components.3)

        let lightHueColor = UIColor(hue: min(huecomponents.0, 1.0),
                                    saturation: min(huecomponents.1 + 0.2, 1.0),
                                    brightness: min(huecomponents.2 + 0.2, 1.0),
                                    alpha: huecomponents.3)

        let darkHueColor = UIColor(hue: max(huecomponents.0 , 0.0),
                                   saturation: max(huecomponents.1, 0.0),
                                   brightness: max(huecomponents.2 - 0.2, 0.0),
                                   alpha: huecomponents.3)

//        let lightColor = UIColor(red: min(components.0 + 0.2, 1.0),
//                                 green: min(components.1 + 0.2, 1.0),
//                                 blue: min(components.2 + 0.2, 1.0),
//                                 alpha: components.3)
//
//        let darkColor = UIColor(red: max(components.0 - 0.1, 0.0),
//                                green: max(components.1 - 0.1, 0.0),
//                                blue: max(components.2 - 0.1, 0.0),
//                                alpha: components.3)

        return (lightHueColor, color, darkHueColor)

    }
}

extension UIView {

    @discardableResult func gradientFromColor(_ color: UIColor) -> CAGradientLayer {
        let colors = BEColorGenerator.generateMapOfColors(from: color)

        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [colors.0.cgColor, colors.2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)

        gradient.frame = self.frame
        self.layer.insertSublayer(gradient, at: 0)

        return gradient
    }
}
