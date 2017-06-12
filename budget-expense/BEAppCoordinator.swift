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

    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    var rootViewController: UIViewController?

    init() {
        self.rootViewController = storyboard.instantiateInitialViewController()

        if let rootVC = self.rootViewController as? BEHomeViewController {
            rootVC.delegate = self
        }
    }

    //MARK:- HOMEVIEWCONTROLLER
    func didSelectExpenseScreen(_ homeViewController: BEHomeViewController) {
        // Expense screen loading

        guard let addDataVC = self.storyboard.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) as? BEAddDataViewController else { return }

        addDataVC.type = .expense
        homeViewController.presentAnimator = BETransitioningPresentingAnimator(direction: .up)
        addDataVC.transitioningDelegate = homeViewController

        homeViewController.present(addDataVC, animated: true) { 
            SQFeedbackGenerator().generateFeedback(type: .notification)
        }
    }


    func didSelectListScreen(_ homeViewController: BEHomeViewController) {
        homeViewController.performSegue(withIdentifier: "BEViewTransactionsSegue", sender: nil)
    }

    func didSelectIncomeScreen(_ homeViewController: BEHomeViewController) {
        guard let addDataVC = self.storyboard.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) as? BEAddDataViewController else { return }

        addDataVC.type = .income
        homeViewController.presentAnimator = BETransitioningPresentingAnimator(direction: .down)
        addDataVC.transitioningDelegate = homeViewController

        homeViewController.present(addDataVC, animated: true) {
            SQFeedbackGenerator().generateFeedback(type: .notification)
        }
    }

}
