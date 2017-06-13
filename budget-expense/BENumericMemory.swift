//
//  BENumericMemory.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

class Stack<T: CustomStringConvertible> {
    private var basemem = [T]()

    func addElement(element: T) {
        self.basemem.append(element)
    }

    func removeElement() {
        if self.basemem.isEmpty == false {
            self.basemem.removeLast()
        }
    }

    func toDecimal() -> Double {
        if basemem.isEmpty {
            return 0.00
        }
        guard let retVal = Double(basemem.map{ $0.description }.joined()) else { fatalError() }
        return retVal / 100.0
    }
}


struct NumericMem {

    var numberStack = Stack<String>()

    func toNumber() -> NSNumber {
        return NSNumber(value: self.toDouble())
    }

    func toDouble() -> Double {
        return self.numberStack.toDecimal()
    }

    mutating func addDigit(digit: String) {
        let characters = digit.characters.map { String($0) }

        for char in characters {
            self.numberStack.addElement(element: char)
        }
    }

    mutating func removeDigit() {
        self.numberStack.removeElement()
    }
}
