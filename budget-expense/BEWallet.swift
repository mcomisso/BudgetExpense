//
//  BEWallet.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import RealmSwift

class Account: BEBaseModel {

    @objc dynamic var name = ""
    let amounts = List<Amount>()
}
