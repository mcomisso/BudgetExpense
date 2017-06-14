//
//  BEDefaultsModel.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Iconic
import Material

struct BEInitialData {
    struct Categories {
        static let travel = BECategory(gliph: FontAwesomeIcon.planeIcon.name, color: Color.indigo.base)
        static let business = BECategory(gliph: FontAwesomeIcon.buildingIcon.name, color: Color.blueGrey.base)
        static let eat = BECategory(gliph: FontAwesomeIcon.foodIcon.name, color: Color.deepOrange.base)
        static let home = BECategory(gliph: FontAwesomeIcon.homeIcon.name, color: Color.brown)
        static let appStore = BECategory(gliph: FontAwesomeIcon.appleIcon.name, color: Color.blue)
    }

    func loadIntoRealm() {

        let categories: [BECategory] = [Categories.travel,
                                        Categories.business,
                                        Categories.appStore,
                                        Categories.business,
                                        Categories.eat,
                                        Categories.home]

        for cat in categories {
            BERealmManager.shared.saveCategory(cat)
        }

    }
}
