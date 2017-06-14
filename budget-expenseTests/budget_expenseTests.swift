//
//  budget_expenseTests.swift
//  budget-expenseTests
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import XCTest
@testable import budget_expense

class budget_expenseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNumericMemory() {

        var numericMemory = NumericMem(numberStack: Stack<String>())

        numericMemory.addDigit(digit: "5")

        print(numericMemory.toDouble())
        print(numericMemory.toNumber())

        XCTAssert(numericMemory.toDouble() == 0.05)

        XCTAssert(numericMemory.toNumber().isEqual(to: NSNumber.init(value: 0.05)))

        numericMemory.removeDigit()
        numericMemory.addDigit(digit: "55")

        numericMemory.addDigit(digit: "asd")
        print(numericMemory.toDouble())

    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
