//
//  BEStartViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 07/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import FSLineChart
import Material

class BEHomeViewController: UIViewController {

    @IBOutlet weak var lineChart: FSLineChart!

    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var arrowUp: UIImageView!

    @IBOutlet weak var amountDisplay: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

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

        self.lineChart.animationDuration = 0
        self.lineChart.axisColor = .clear // the X Y axis
        self.lineChart.drawInnerGrid = false
        self.lineChart.bezierSmoothingTension = 0.5
        self.lineChart.axisLineWidth = 0.0
        self.lineChart.lineWidth = 4.0
        self.lineChart.color = BETheme.Colors.darkPrimary
        self.lineChart.fillColor = BETheme.Colors.primary
        self.lineChart.backgroundColor = .clear
        self.lineChart.verticalGridStep = 10
        self.lineChart.horizontalGridStep = 1
        self.lineChart.margin = 0.0

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

        self.amountDisplay.text = BERealmManager.shared.getAmount()

        let chartData = BERealmManager.shared.getWeekData()
        lineChart.clearData()
        lineChart.setChartData(chartData)
    }

}

extension BEHomeViewController: UIGestureRecognizerDelegate {
    func inputData(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.down:
            // Add income
            guard let addDataVC = self.storyboard?.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) as? BEAddDataViewController else {
                break
            }
            addDataVC.type = .income
            self.present(addDataVC, animated: true, completion: nil)
        case UISwipeGestureRecognizerDirection.up:
            // Add expense
            guard let addDataVC = self.storyboard?.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) as? BEAddDataViewController else {
                break
            }
            addDataVC.type = .expense
            self.present(addDataVC, animated: true, completion: nil)
        default:
            break
            // Do nothing
        }
    }
}
