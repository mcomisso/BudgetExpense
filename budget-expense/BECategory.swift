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

    @objc dynamic var name: String = ""

    // This describes the icon gliph
    @objc dynamic var icon: String = ""

    @objc dynamic var colorData: Data = Data()

    var color: UIColor {
        get {
            guard let color = NSKeyedUnarchiver.unarchiveObject(with: self.colorData) as? UIColor else {
                return .white
            }
            return color
        }

        set {
            self.colorData = NSKeyedArchiver.archivedData(withRootObject: newValue)
        }
    }

    convenience init(gliph: String, color: UIColor, name: String) {
        self.init()
        self.icon = gliph
        self.color = color
        self.name = name
    }

    override class func ignoredProperties() -> [String] { return ["color"] }

}
