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
import AlertOnboarding
import SQFeedbackGenerator

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

class BEHomeViewController: UIViewController {

    weak var delegate: BEHomeViewControllerDelegate?

    @IBOutlet weak var chartView: ChartView!

    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var arrowUp: UIImageView!

    @IBOutlet weak var amountDisplay: UILabel!

    lazy var onboarding: AlertOnboarding = { [weak self] in
        guard let `self` = self else { fatalError() }

        let images = ["first"]
        let titles = ["Title"]
        let descriptions = ["Description"]

        let ao = AlertOnboarding(arrayOfImage: images, arrayOfTitle: titles, arrayOfDescription: descriptions)
        ao.delegate = self
        ao.titleSkipButton = "SKIP"
        ao.titleGotItButton = "im done"
        return ao
    }()

    var presentAnimator: BETransitioningPresentingAnimator? = nil

    fileprivate var chart: Chart?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountDisplay.textColor = BETheme.Colors.textIcons
        self.view.backgroundColor = Color.teal.lighten5

        self.arrowUp.tintColor = Color.grey.lighten5
        self.arrowDown.tintColor = Color.grey.lighten5
        self.incomeLabel.textColor = Color.grey.lighten5
        self.expenseLabel.textColor = Color.grey.lighten5

        self.arrowUp.contentMode = .scaleAspectFit
        self.arrowUp.image = Icon.cm.arrowDownward
        self.arrowUp.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.arrowDown.image = Icon.cm.arrowDownward
        self.arrowDown.contentMode = .scaleAspectFit

        self.view.backgroundColor = BETheme.Colors.divider
        self.amountDisplay.textColor = BETheme.Colors.primaryText

        let chartConfig = ChartConfigXY(xAxisConfig: ChartAxisConfig(from: 0, to: 7, by: 1), yAxisConfig: ChartAxisConfig(from: -10, to: 10, by: 2))

        let values = BERealmManager.shared.getWeekData()

        var arr = [(Double, Double)]()
        for (index, value) in values.enumerated() {
            arr.append((Double(index), value))
        }

        let chartLine = (chartPoints: arr, color: UIColor.red)

        let chart = LineChart(frame: self.chartView.frame, chartConfig: chartConfig, xTitle: "", yTitle: "", line: chartLine)

        self.chart = chart

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.transform = CGAffineTransform.identity

        self.amountDisplay.text = BEUtils.formatNumberToCurrency(number: BERealmManager.shared.getAmount())

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.bool(forKey: "onboarded") == false {
            self.presentOnboarding()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Insert here preparation
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

extension BEHomeViewController: AlertOnboardingDelegate {

    func presentOnboarding() {
        self.onboarding.show()
    }

    func setupOnboarding() {

    }

    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Skipped onboarding")
    }

    func alertOnboardingCompleted() {
        print("Completed onboarding")
        UserDefaults.standard.set(true, forKey:"onboarded")
    }

    func alertOnboardingNext(_ nextStep: Int) {
        print("Next onboarding")
    }
}
