//
//  BECategory.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift

class BECategory: BEBaseModel, BECategoryProtocol {

    dynamic var name: String = ""

    // This describes the icon gliph
    dynamic var icon: String = ""

    dynamic var colorData: Data = Data()

    var color: UIColor {
        get {
            return NSKeyedUnarchiver.unarchiveObject(with: self.colorData) as! UIColor
        }

        set {
            self.colorData = NSKeyedArchiver.archivedData(withRootObject: newValue)
        }
    }



    convenience init(gliph: String, color: UIColor) {
        self.init()
        self.icon = gliph
        self.color = color
    }

}
