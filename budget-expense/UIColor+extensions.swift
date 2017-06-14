//
//  BEExtensions.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {

    /**
     Initialize a UIColor from the single RGB values.

     - parameter red:   Red color value
     - parameter green: Green color value
     - parameter blue:  Blue color value

     - returns: An UIColor with the specified values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    //    convenience init(netHex:Int) {
    //        self.init(red:(netHex >> 16) & 0xff, green:(netHex > > 8) & 0xff, blue:netHex & 0xff)
    //    }

    /**
     Initialize a UIColor from the single hex value.

     - parameter hexColor: Hex value
     - parameter alpha:    Alpha value

     - returns: An UIColor from the specified values
     */
    convenience init (hex:String, alpha:CGFloat = 1.0) {

        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;

        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }

        if (cString.characters.count == 6) {
            let rString = (cString as NSString).substring(to: 2)
            let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
            let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)

            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
        }

        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
