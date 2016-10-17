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

class BEHomeViewController: UIViewController {

    @IBOutlet weak var chartView: ChartView!

    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var arrowUp: UIImageView!

    @IBOutlet weak var amountDisplay: UILabel!


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

}

extension BEHomeViewController: UIGestureRecognizerDelegate {
    func inputData(recognizer: UISwipeGestureRecognizer) {

        var feedbackGenerator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()

        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.down:
            // Add income
            guard let addDataVC = self.storyboard?.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) as? BEAddDataViewController else {
                break
            }
            feedbackGenerator?.selectionChanged()
            addDataVC.type = .income
            self.present(addDataVC, animated: true, completion: { 

            })
        case UISwipeGestureRecognizerDirection.up:
            // Add expense
            guard let addDataVC = self.storyboard?.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) as? BEAddDataViewController else {
                break
            }

            feedbackGenerator?.selectionChanged()
            addDataVC.type = .expense
            self.present(addDataVC, animated: true, completion: {
                feedbackGenerator = nil
            })
        default:
            break
            // Do nothing
        }
    }
}
