//
//  BEBaseModel.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift

class BEBaseModel: Object {
    @objc dynamic var id = UUID.init().uuidString

    override class func primaryKey() -> String? { return "id" }
}
