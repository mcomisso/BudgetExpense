//
//  BEStartViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 07/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import Material
import SwiftCharts
import SQFeedbackGenerator
import KDCircularProgress

protocol BEHomeViewControllerDelegate: class {

    /// Expense screen
    ///
    /// - Parameter homeViewController: the source of the event
    func didSelectExpenseScreen(_ homeViewController: BEHomeViewController)

    /// Income screen
    ///
    /// - Parameter homeViewController: the source of the event
    func didSelectIncomeScreen(_ homeViewController: BEHomeViewController)

    /// List screen
    ///
    /// - Parameter homeViewController: The source of the event
    func didSelectListScreen(_ homeViewController: BEHomeViewController)
}



/// The starter ViewController
class BEHomeViewController: UIViewController {

    weak var delegate: BEHomeViewControllerDelegate?

    @IBOutlet weak var chartView: ChartView!

    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var arrowUp: UIImageView!

    @IBOutlet weak var circularProgress: KDCircularProgress!

    @IBOutlet weak var amountDisplay: UILabel!

    var presentAnimator: BETransitioningPresentingAnimator? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareViews()

        self.addGestureRecognizers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.transform = CGAffineTransform.identity

        self.amountDisplay.text =  BERealmManager.shared.getAmount().toCurrency()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.loadHomeData()
    }

}

extension BEHomeViewController {

    func loadHomeData() {

        let amount = BERealmManager.shared.getAmount() as! Double
        let weeklyBudget = 100.0

        let angle = 360.0 * amount / weeklyBudget

        if angle >= 0 && angle <= 360 {
            self.circularProgress.animate(toAngle: angle, duration: 2, completion: nil)
        } else if angle > 360 {
            self.circularProgress.animate(toAngle: 360, duration: 2, completion: nil)
        } else if angle < 0 {
            self.circularProgress.animate(toAngle: 0, duration: 2, completion: nil)
        }



    }
    func addGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(transactionsDetails(recognizer:)))
        self.amountDisplay.addGestureRecognizer(tapGestureRecognizer)
        self.amountDisplay.isUserInteractionEnabled = true

        let expenseGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(inputData(recognizer:)))
        expenseGestureRecognizer.direction = .up
        expenseGestureRecognizer.delegate = self

        let incomeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(inputData(recognizer:)))
        incomeGestureRecognizer.direction = .down
        incomeGestureRecognizer.delegate = self

        self.view.addGestureRecognizer(expenseGestureRecognizer)
        self.view.addGestureRecognizer(incomeGestureRecognizer)
    }

    func prepareViews() {

        self.view.backgroundColor = .white

        self.prepareIncomeArrow()
        self.prepareExpenseArrow()

        self.incomeLabel.textColor = BETheme.Colors.income.withAlphaComponent(0.6)
        self.expenseLabel.textColor = BETheme.Colors.expense.withAlphaComponent(0.6)

        self.amountDisplay.textColor = BETheme.Colors.primaryText
    }

    func prepareExpenseArrow() {
        self.arrowUp.tintColor = BETheme.Colors.expense.withAlphaComponent(0.6)
        self.arrowUp.contentMode = .scaleAspectFit
        self.arrowUp.image = Icon.cm.arrowDownward
        self.arrowUp.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    func prepareIncomeArrow() {
        self.arrowDown.tintColor = BETheme.Colors.income.withAlphaComponent(0.6)
        self.arrowDown.image = Icon.cm.arrowDownward
        self.arrowDown.contentMode = .scaleAspectFit
    }
}

extension BEHomeViewController: UIGestureRecognizerDelegate {

    func transactionsDetails(recognizer: UITapGestureRecognizer) {
        self.delegate?.didSelectListScreen(self)
    }

    func inputData(recognizer: UISwipeGestureRecognizer) {

        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.down:

            // APPCOORDINATOR

            self.delegate?.didSelectIncomeScreen(self)

        case UISwipeGestureRecognizerDirection.up:

            // Transitioning to appCoordinator

            self.delegate?.didSelectExpenseScreen(self)

        default:
            break
            // Do nothing
        }
    }
}

extension BEHomeViewController {
    override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentAnimator
    }

    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil

    }
}
