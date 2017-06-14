//
//  BEInitialSetupViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 14/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit
import Material


struct InitializerData {
    let title: String
    let description: String
    let image: UIImage
    let numberOfActions: Int
    let completionAction: (Bool) -> Void
}

final class BEInitialSetupNavigationController: UINavigationController {

    var setupViewControllers: [BEInitialSetupViewController] = []

    var index: Int = 0

    lazy var dataSource: [InitializerData] = {

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
                                                                }

                                                                self?.loadNext()
        }

        return [welcomePage, notificationControl, locationControl]
    }()


    func loadNext() {
        guard let nextVC = R.storyboard.initialStartup.requestController() else { self.dismiss(animated: true, completion: nil); return }

        self.index += 1

        nextVC.setup(self.dataSource[index])
        self.pushViewController(nextVC, animated: true)
    }

}

class BEInitialSetupViewController: UIViewController {

    private var titleDescription: String? {
        didSet {
            self.titleLabel.text = titleDescription
        }
    }

    private var descriptionString: String? {
        didSet {
            self.descriptionLabel.text = descriptionString
        }
    }
    
    private var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    private var completion: ((Bool) -> Void)?
    
    private var data: InitializerData!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var doNotAcceptButton: Button!
    @IBOutlet weak var acceptButton: FlatButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.acceptButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        self.doNotAcceptButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
    
    func setup(_ data: InitializerData) {
        
        self.image = data.image
        self.titleDescription = data.title
        self.descriptionString = data.description
        self.completion = data.completionAction
    }
    
    func continueAction(_ sender: UIButton) {
        
    }
    
    func loadNextPage() {
        
    }
}
