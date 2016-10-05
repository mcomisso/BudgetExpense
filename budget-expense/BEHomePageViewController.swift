//
//  SecondViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit

enum BEExpenseAction: Int {
    case expense = 100
    case income = 200
}

class BEHomePageViewController: BEViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let addExpense = UIButton(type: .custom)
        addExpense.tintColor = UIColor.purple
        addExpense.setTitle("Add Expense", for: .normal)
        addExpense.tag = BEExpenseAction.expense.rawValue
        addExpense.target(forAction: #selector(self.actionButtonPressed(sender:)), withSender: addExpense)

        let addIncome = UIButton(type: .custom)
        addExpense.tintColor = UIColor.blue
        addIncome.setTitle("Add Income", for: .normal)
        addIncome.tag = BEExpenseAction.income.rawValue
        addIncome.target(forAction: #selector(self.actionButtonPressed(sender:)), withSender: addIncome)

        // Stackviews
        let stackView = UIStackView(arrangedSubviews: [addExpense, addIncome])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.axis = .horizontal

        self.view.addSubview(stackView)

        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func actionButtonPressed(sender: AnyObject) {
        if let button = sender as? UIButton {
            if button.tag == BEExpenseAction.expense.rawValue {


            } else if button.tag == BEExpenseAction.income.rawValue {


            }

            let addDataViewController = BEAddDataViewController()
            self.navigationController?.pushViewController(addDataViewController, animated: true)
        }
    }
}

