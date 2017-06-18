//
//  BESettingsViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 18/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//
import UIKit
import Foundation
import Eureka
import StoreKit

final class BESettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section("Section1")
            <<< TextRow(){ row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Currency")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            +++ Section("Credits")
            <<< PushRow<String>() {
                $0.title = "Available currencies"
                $0.options = BERealmManager.shared.listCurrencies()
                $0.selectorTitle = "Select currency" }
            +++ Section("Support")
            <<< URLRow() {
                $0.title = "website"
                $0.value = URL(string: "http://mcomisso.xyz")!
            }
            <<< EmailRow() {
                $0.title = "Support"
                $0.value = "comisso.matteo89+currency@gmail.com"
            }
            <<< TwitterRow() {
                $0.title = "Twitter"
                $0.value = "@teomatteo89"
            }
        if #available(iOS 10.3, *) {
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Write a review"
            }.onCellSelection({ (cell, row) in
                SKStoreReviewController.requestReview()
            })
        }
        form +++ Section()
        <<< ButtonRow() {
            $0.title = "Reset all data"
        }.onCellSelection({[weak self] (cell, row) in
            let actionsheet = UIAlertController.init(title: "Are you sure?", message: "There is no recovery for this option", preferredStyle: .actionSheet)
            actionsheet.addAction(UIAlertAction.init(title: "Yes, delete all my data", style: .destructive, handler: { (action) in
                BERealmManager.shared.deleteAllData()
            }))
            actionsheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self?.present(actionsheet, animated: true, completion: nil)
        })


        self.navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        self.animateScroll = true
        self.rowKeyboardSpacing = 20
    }
}
