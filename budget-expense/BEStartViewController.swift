//
//  BEStartViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 07/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import FSLineChart

class BEHomeViewController: UIViewController {

    @IBOutlet weak var lineChart: FSLineChart!

    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!

    @IBOutlet weak var amountDisplay: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lineChart.animationDuration = 0
        self.lineChart.axisColor = .clear // the X Y axis
        self.lineChart.drawInnerGrid = false
        self.lineChart.bezierSmoothingTension = 0.5
        self.lineChart.axisLineWidth = 0.0
        self.lineChart.lineWidth = 4.0

        self.lineChart.color = .purple
        self.lineChart.fillColor = .purple

        let chartData = [23, -13, 24]

        let max = Int32(chartData.max()!)

        self.lineChart.verticalGridStep = 10
        self.lineChart.horizontalGridStep = 1
        self.lineChart.margin = 0.0
//        self.lineChart.axisHeight = self.lineChart.frame.size.width / CGFloat(max)
//        self.lineChart.axisWidth = self.lineChart.frame.size.width / 7.0

        lineChart.setChartData(chartData)

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
    }

}

extension BEHomeViewController: UIGestureRecognizerDelegate {
    func inputData(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.down:
            // Add income
            guard let addDataVC = self.storyboard?.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) else {
                break
            }
            self.present(addDataVC, animated: true, completion: nil)
        case UISwipeGestureRecognizerDirection.down:
            // Add expense
            guard let addDataVC = self.storyboard?.instantiateViewController(withIdentifier: BEConstants.Identifiers.addDataViewController) else {
                break
            }
            self.present(addDataVC, animated: true, completion: nil)
        default:
            break
            // Do nothing
        }
    }
}
