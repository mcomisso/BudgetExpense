//
//  BEModelProtocols.swift
//  budget-expense
//
//  Created by Matteo Comisso on 11/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

//MARK: AMOUNT protocol

protocol BEAmount {
    var id: String { get }
    var amount: Double { get }
    var isExpense: Bool { get }
    var notes: String { get }
    var creationDate: Date? { get }

    var modificationDate: Date? { get }
}

// MARK: CATEGORY

protocol BECategory {

    var name: String { get }
    var icon: Data { get }
    var color: String { get }
}

//MARK: ACCOUNT Protocol

protocol BEAccount {
    var id: String { get }
    var name: String { get }
    var currency: String { get }
    var creationDate: Date? { get }
    var modificationDate: Date? { get }
}



// MARK: MANAGER Protocol

protocol BEManager {

    /// Get the current amount
    ///
    /// - returns: A string representing the current amount
    func getAmount() -> NSNumber

    /// Get Amount data for a tableView representation
    ///
    /// - returns: Returns a Realm results with amount
    func getWeekDataForTableView() -> [BEAmount]


    /// Gets the weekly data. The set date is the most recent.
    ///
    /// - parameter date: The date to start (topmost date)
    ///
    /// - returns: Return an array of double values
    func getWeekData(to date: Date) -> [Double]

    /// Get the list of categories
    ///
    /// - returns: Return a Results list of categories
    func getCategories() -> [BECategory]?


    /// Save an amount
    ///
    /// - parameter amount: Value of the amount
    /// - parameter type:   Expense or Income
    /// - parameter notes:  Optional notes
    /// - parameter date:   Optional date
    func save(amount: Double, type: BEAddDataType, notes: String, date: Date)

}
