//
//  BEAppCoordinator.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import SQFeedbackGenerator


class BEAppCoordinator: BEHomeViewControllerDelegate {

    // Storyboards

    let mainStoryboard = R.storyboard.main()
    let transactionsStoryboard = R.storyboard.transactions()
    let initialStoryboard = R.storyboard.initialStartup()
    let categoriesStoryboard = R.storyboard.categories()

    var rootViewController: UIViewController?

    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        if BESettings.needsFirstRun.boolValue == true {
            self.rootViewController = self.initialStoryboard.instantiateInitialViewController()

            if let rootVC = self.rootViewController as? BEInitialSetupNavigationController {
                rootVC.setupDelegate = self
            }

        } else {
            self.rootViewController = self.mainStoryboard.instantiateInitialViewController()

            if let rootVC = self.rootViewController as? BEHomeViewController {
                rootVC.delegate = self
            }
        }

        self.window?.rootViewController = self.rootViewController
    }


    //MARK:- HOMEVIEWCONTROLLER
    func didSelectExpenseScreen(_ homeViewController: BEHomeViewController) {
        // Expense screen loading

        guard let addDataVC = R.storyboard.main.addDataViewController() else { return }

        addDataVC.type = .expense
        homeViewController.presentAnimator = BETransitioningPresentingAnimator(direction: .up)
        addDataVC.transitioningDelegate = homeViewController

        homeViewController.present(addDataVC, animated: true) { 
            SQFeedbackGenerator().generateFeedback(type: .notification)
        }
    }


    func didSelectListScreen(_ homeViewController: BEHomeViewController) {
        if let transactionListVC = R.storyboard.transactions.transactionsNavigationController() {
            homeViewController.present(transactionListVC, animated: true, completion: nil)
        }
    }


    func didSelectIncomeScreen(_ homeViewController: BEHomeViewController) {
        guard let addDataVC = R.storyboard.main.addDataViewController() else { return }

        addDataVC.type = .income
        homeViewController.presentAnimator = BETransitioningPresentingAnimator(direction: .down)
        addDataVC.transitioningDelegate = homeViewController

        homeViewController.present(addDataVC, animated: true) {
            SQFeedbackGenerator().generateFeedback(type: .notification)
        }
    }

}


extension BEAppCoordinator: BEInitialSetupNavigationControllerDelegate {

    func didDismissNavigationController(_ navigationController: BEInitialSetupNavigationController) {
        BESettings.needsFirstRun.set(value: false)
        self.start()
    }

}
