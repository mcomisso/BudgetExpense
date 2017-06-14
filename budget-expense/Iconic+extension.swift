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
    static func standardDimension(icon: FontAwesomeIcon) -> UIImage {
        return Iconic.image(withIcon: icon, size: CGSize.init(width: 50, height: 50), color: .blue)
    }
}
