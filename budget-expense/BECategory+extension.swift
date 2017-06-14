//
//  BECategory+extension.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Iconic

extension BECategory {
    func generateImageFromIcon() -> UIImage {
        let icon = FontAwesomeIcon(named: self.name)
        return Iconic.standardDimension(icon: icon, size: CGSize.init(width: 30, height: 30), color: .white)

    }
}
