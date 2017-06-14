//
//  UserDefaults+extension.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

extension UserDefaults {
    func safeSet(_ value: Bool, forKey: String) {
        if self.object(forKey: forKey) == nil {
            self.set(value, forKey: forKey)
        }
    }
}
