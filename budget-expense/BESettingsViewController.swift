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
import Material
import AcknowList

final class BESettingsViewController: FormViewController {

    @IBOutlet weak var closeBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.closeBarButton.image = Icon.close
        self.closeBarButton.title = ""

        //MARK: GENERAL
        /*
         In-App Purchase
         iCloud

         */

        form +++ Section("General")
            <<< PhoneRow(){ row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
            }
            <<< SwitchRow() { row in
                row.title = "iCloud Enabled"
                row.value = BESettings.appSoundsEnabled.boolValue
        }


        //MARK: REVIEW

        form +++ Section()
        if #available(iOS 10.3, *) {
            form.last! <<< ButtonRow() {
                $0.title = "Write a review"
                }.onCellSelection({ (cell, row) in
                    SKStoreReviewController.requestReview()
                })
        }
        form.last!
            <<< ButtonRow() {
                $0.title = "Send feedback"
                }.onCellSelection({ (cell, row) in
                    // Open
                })


        //MARK: SUPPORT

        form +++ Section("Support")
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


        //MARK: WARNING ZONE

        form +++ Section("Warning zone")
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


        //MARK: SHARE

        form +++ Section("Share")
            <<< ButtonRow() {
                $0.title = "Email"
                }.onCellSelection({ (cell, row) in
                    // Share on twitter
                })
            <<< ButtonRow() {
                $0.title = "Whatsapp"
                }.onCellSelection({ (cell, row) in
                    // Share on twitter
                })
            <<< ButtonRow() {
                $0.title = "Twitter"
                }.onCellSelection({ (cell, row) in
                    // Share on twitter
                })
            <<< ButtonRow() {
                $0.title = "Facebook"
                }.onCellSelection({ (cell, row) in
                    // Share on twitter
                })

        //MARK: CREDITS

        form +++ Section("Credits")
            <<< PushRow<String>() {
                $0.title = "Available currencies"
                $0.options = BERealmManager.shared.listCurrencies()
                $0.selectorTitle = "Select currency" }
            <<< ButtonRow() {
                $0.title = "Acknowledgments"
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> AcknowListViewController in
                    let path = Bundle.main.path(forResource: "Pods-budget-expense-acknowledgements", ofType: "plist")
                    let cv = AcknowListViewController.init(acknowledgementsPlistPath: path)
                    return cv
                }), onDismiss: nil)

        }

        self.navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        self.animateScroll = true
        self.rowKeyboardSpacing = 20
    }

    @IBAction func closeAction(_ sender: Any) {
        self.closeViewController()
    }
    
    func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
