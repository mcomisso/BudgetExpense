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
import MessageUI
import Social
import Crashlytics
import PKHUD

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
        if BEConstants.Features.CLOUD_KIT_ENABLED {
            form.last!
                <<< SwitchRow() { row in
                    row.title = "iCloud Enabled"
                    row.value = BESettings.iCloudEnabled.boolValue
                    }.onChange({ row in
                        BESettings.iCloudEnabled.set(value: row.value!)
                    })
        }
        form.last!
            <<< PushRow<String>() {
                $0.title = "Base Currency"
                $0.value = BERealmManager.shared.getBaseCurrency()?.currency
                $0.options = BERealmManager.shared.listCurrencies()
                $0.selectorTitle = "Select currency" }.onChange({ (row) in
                    guard let currencyCode = row.value else { return }
                    // Set BASE currency (not active)
                    BERealmManager.shared.setCurrency(forActiveCurrency: false, currencyCode: currencyCode)
                })
            <<< PushRow<String>() {
                $0.title = "Active Currency"
                $0.value = BERealmManager.shared.getActiveCurrency()?.currency
                $0.options = BERealmManager.shared.listCurrencies()
                $0.selectorTitle = "Select Active Currency"

            }.onChange({ (row) in
                guard let currencyCode = row.value else { return }

                // Needs to set it to false, otherwise will overwrite again
                BESettings.automaticGeolocation.set(value: false)

                BERealmManager.shared.setCurrency(forActiveCurrency: true, currencyCode: currencyCode)
            })
            <<< SwitchRow() { row in
                row.title = "Automatic geolocation"
                row.value = BESettings.automaticGeolocation.boolValue
                }.onChange({ row in
                    BESettings.automaticGeolocation.set(value: row.value!)
                })
            <<< SwitchRow() { row in
                row.title = "Sounds enabled"
                row.value = BESettings.appSoundsEnabled.boolValue
                }.onChange({ (row) in
                    BESettings.appSoundsEnabled.set(value: row.value!)
                })
            <<< SwitchRow() {
                $0.title = "Haptic feedback"
                $0.value = BESettings.hapticFeedbackEnabled.boolValue
                }.onChange({ (row) in
                    BESettings.hapticFeedbackEnabled.set(value: row.value!)
                })


        //MARK: REVIEW

        form +++ Section()
        if #available(iOS 10.3, *) {
            form.last! <<< ButtonRow() {
                $0.title = "Write a review"
                }.onCellSelection({ (cell, row) in
                    SKStoreReviewController.requestReview()
                })
        }
        if MFMailComposeViewController.canSendMail() {
            form.last!
                <<< ButtonRow() {
                    $0.title = "Send feedback"
                    }.onCellSelection({ [unowned self] (cell, row) in
                        // Open
                        let composer = MFMailComposeViewController()
                        composer.mailComposeDelegate = self
                        composer.setSubject("Feedback")
                        let deviceDetails = "\n\n\nDevice Details:\n\(UIDevice.current.model)\n\(UIDevice.current.name)\n\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
                        composer.setMessageBody(deviceDetails, isHTML: false)
                        self.present(composer, animated: true, completion: nil)
                    })
        }


        //MARK: WARNING ZONE

        form +++ Section("Warning zone")
            <<< ButtonRow() {
                $0.title = "Refresh exchange rates"
                }.onCellSelection({ (cell, row) in
                    let currencyWebService = BECurrencyWebService()
                    HUD.show(HUDContentType.labeledProgress(title: "Fetching rates...", subtitle: nil))
                    currencyWebService.fetchUpdatedRates(completion: { success in
                        if success {
                            HUD.hide()
                        } else {
                            HUD.flash(.error)
                        }

                    })
                })
            <<< ButtonRow() {
                $0.title = "Reset all data"
                }.onCellSelection({[weak self] (cell, row) in
                    let actionsheet = UIAlertController.init(title: "Are you sure?", message: "There is no recovery for this option", preferredStyle: .actionSheet)
                    actionsheet.addAction(UIAlertAction.init(title: "Yes, delete all my data", style: .destructive, handler: { (action) in
                        BERealmManager.shared.deleteAllData()
                    }))
                    actionsheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                    self?.present(actionsheet, animated: true, completion: nil)
                }).cellUpdate({ (cell, row) in
                    cell.textLabel?.textColor = .red
                })


        //MARK: IMPORT EXPORT

        form +++ Section("Import/export")
            <<< ButtonRow() {
                $0.title = "Import"
                }.onCellSelection({ (cell, row) in
                    // Present the import flow
                })
            <<< ButtonRow() {
                $0.title = "Export"
                }.onCellSelection({ (cell, row) in
                    // Present the export flow
                })


        //MARK: SUPPORT

        form +++ Section("Support")
            <<< URLRow() {
                $0.title = "website"
                $0.value = URL(string: "http://mcomisso.xyz")!
            }
            <<< TwitterRow() {
                $0.title = "Twitter"
                $0.value = "@teomatteo89"
                }.onCellSelection({ (cell, row) in
                    let url = URL(string: "twitter://user?screen_name=teomatteo89")!
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }).cellUpdate({ (cell, row) in
                    cell.textField.isEnabled = false
                })
            <<< ActionSheetRow<String>() {

                let actions = ["Email", "Whatsapp", "Facebook", "Twitter"]

                $0.title = "Share with email, facebook, twitter, etc.."
                $0.selectorTitle = "Select your channel"
                $0.options = actions
                }.onChange({[weak self] (row) in
                    self?.performShareActionFor(string: row.value!)
                })


        //MARK: CREDITS

        form +++ Section("Credits")
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

    func performShareActionFor(string: String) {

        let body = "Share this message"
        let subject = "Have you tried BUDGET EXPENSE?"

        switch string.lowercased() {
        case "email":
            if MFMailComposeViewController.canSendMail() {
                let composer = MFMailComposeViewController()
                composer.mailComposeDelegate = self
                composer.setMessageBody(body, isHTML: false)
                composer.setSubject(subject)

                self.present(composer, animated: true) {
                    Answers.logShare(withMethod: string, contentName: "Share app", contentType: nil, contentId: nil, customAttributes: nil)
                }
            }

        case "facebook": // MAYBE NEEDS FACEBOOK FRAMEWORK...
            Answers.logShare(withMethod: string, contentName: "Share app", contentType: nil, contentId: nil, customAttributes: nil)
            break
        case "twitter": // MAYBE NEEDS TWITTER FRAMEWORK...
            Answers.logShare(withMethod: string, contentName: "Share app", contentType: nil, contentId: nil, customAttributes: nil)
            break
        case "whatsapp":
            Answers.logShare(withMethod: string, contentName: "Share app", contentType: nil, contentId: nil, customAttributes: nil)
            break
        case "imessage":

            if MFMessageComposeViewController.canSendText() {
                let composer = MFMessageComposeViewController()
                composer.messageComposeDelegate = self

                composer.body = subject + " " + body

                self.present(composer, animated: true) {
                    Answers.logShare(withMethod: string, contentName: "Share app", contentType: nil, contentId: nil, customAttributes: nil)
                }
            }
        default:
            fatalError("Not handled")
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.closeViewController()
    }

    func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BESettingsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        if let error = error {
            print(error.localizedDescription)
        }

        switch result {
        case .cancelled:
            Answers.logShare(withMethod: "Mail composer", contentName: nil, contentType: "Cancelled", contentId: nil, customAttributes: nil)
        case .failed:
            Answers.logShare(withMethod: "Mail composer", contentName: nil, contentType: "Failed", contentId: nil, customAttributes: nil)
        case .saved:
            Answers.logShare(withMethod: "Mail composer", contentName: nil, contentType: "Saved", contentId: nil, customAttributes: nil)
        case .sent:
            Answers.logShare(withMethod: "Mail composer", contentName: nil, contentType: "Sent", contentId: nil, customAttributes: nil)
        }

        controller.dismiss(animated: true, completion: nil)
    }

}

extension BESettingsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        defer {
            controller.dismiss(animated: true, completion: nil)
        }
        switch result {
        case .cancelled:
            Answers.logShare(withMethod: "Message composer", contentName: nil, contentType: "Cancelled", contentId: nil, customAttributes: nil)
        case .failed:
            Answers.logShare(withMethod: "Message composer", contentName: nil, contentType: "Failed", contentId: nil, customAttributes: nil)
        case .sent:
            Answers.logShare(withMethod: "Message composer", contentName: nil, contentType: "Sent", contentId: nil, customAttributes: nil)
        }
    }
}
