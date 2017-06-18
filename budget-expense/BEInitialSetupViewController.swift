//
//  BEInitialSetupViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit
import Material
import Presentr

struct InitializerData {
    let title: String
    let description: String
    let image: UIImage
    let numberOfActions: Int
    let completionAction: (Bool) -> Void
}

protocol BEInitialSetupNavigationControllerDelegate: class {
    func didDismissNavigationController(_ navigationController: BEInitialSetupNavigationController)
}

final class BEInitialSetupNavigationController: UINavigationController {

    var setupViewControllers: [BEInitialSetupViewController] = []

    var index: Int = 0

    weak var setupDelegate: BEInitialSetupNavigationControllerDelegate?

    private let presentr: Presentr = {
        let p = Presentr(presentationType: .popup)
        return p
    }()

    var dataSource: [InitializerData] = []

    func setupInitData() {
        let welcomePage: InitializerData = InitializerData(title: "Welcome to BUDGET EXPENSE",
                                                           description: "Thank you for purchasing Budget Expense!Thank you for purchasing Budget Expense!Thank you for purchasing Budget Expense!Thank you for purchasing Budget Expense!",
                                                           image: #imageLiteral(resourceName: "add"),
                                                           numberOfActions: 1) { [weak self] (_) in

                                                            // Continue
                                                            self?.loadNext()
        }

        let notificationControl: InitializerData = InitializerData(title: "Allow notification?",
                                                                   description: "Notifications are needed to allow iCloud syncing in realtime",
                                                                   image: #imageLiteral(resourceName: "cloud"),
                                                                   numberOfActions: 2) {  [weak self] (accepted) in
                                                                    // Code

                                                                    if accepted {
                                                                        // ask notification

                                                                    }

                                                                    self?.loadNext()
        }

        let locationControl: InitializerData = InitializerData(title: "Allow location access?",
                                                               description: "Location is used to determine your current country and automatically adjust the currency.",
                                                               image: #imageLiteral(resourceName: "location"),
                                                               numberOfActions: 2) { [weak self] (accepted) in
                                                                // Code

                                                                if accepted {
                                                                    // Ask location
                                                                    BELocationManager.shared.requestAuthorization(successCallback: { 
                                                                        self?.loadNext()
                                                                    })
                                                                }
        }

        let currencySetup: InitializerData = InitializerData(title: "Select currency", description: "Your device is configured with \(String(describing: NSLocale.current.currencyCode)) currency. Is that correct?", image: UIImage(named: "stats")!, numberOfActions: 2) { [weak self] (currencyCorrect) in
            if currencyCorrect {
                // Just continue
                self?.loadNext()
            } else {
                // Present the currency selector screen

                guard let currencySelector = R.storyboard.initialStartup.currencySelectorViewController() else { return }

                self?.customPresentViewController((self?.presentr)!, viewController: currencySelector, animated: true, completion: nil)
            }
        }

        self.dataSource = [welcomePage, notificationControl, locationControl, currencySetup]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitData()

        print(self.childViewControllers)

        print(self.setupViewControllers)

        print(self.viewControllers)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.viewControllers.first as! BEInitialSetupViewController).setup(self.dataSource.first!)

    }

    func loadNext() {
        guard let nextVC = R.storyboard.initialStartup.requestController() else { self.dismiss(animated: true, completion: nil); return }

        self.index += 1

        if self.index < self.dataSource.count {
            nextVC.setup(self.dataSource[index])
            self.pushViewController(nextVC, animated: true)
        } else {
            self.complete()
        }
    }

    func complete() {

        self.dismiss(animated: true) { 
            self.setupDelegate?.didDismissNavigationController(self)
        }
    }

}

final class BEInitialSetupViewController: UIViewController {

    private var data: InitializerData?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var doNotAcceptButton: Button!
    @IBOutlet weak var acceptButton: FlatButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.acceptButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        self.doNotAcceptButton.addTarget(self, action: #selector(loadNextPage), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let data = self.data else { return }
        self.imageView.image = data.image
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.description
    }
    
    func setup(_ data: InitializerData) {
        self.data = data
    }

    func continueAction(_ sender: UIButton) {
        self.data?.completionAction(true)
    }
    
    func loadNextPage() {
        self.data?.completionAction(false)
    }
}
