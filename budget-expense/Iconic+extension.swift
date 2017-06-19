//
//  Iconic+extension.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Iconic

extension Iconic {

    static func defaultDimension(icon: FontAwesomeIcon, color: UIColor = .blue) -> UIImage {
        return Iconic.standardDimension(icon: icon, color: color)
    }

    static func standardDimension(icon: FontAwesomeIcon, size: CGSize = CGSize(width: 50, height: 50), color: UIColor = .blue) -> UIImage {
        return Iconic.image(withIcon: icon, size: size, color: color)
    }
}
