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

        let amountLabel = UILabel(frame: CGRect.zero)
        amountLabel.font = UIFont.boldSystemFont(ofSize: 60)
        amountLabel.text = "15782,23"
        amountLabel.textAlignment = .center

        let addExpenseButton = UIButton(type: .custom)
        addExpenseButton.setTitleColor(UIColor.purple, for: .normal)
        addExpenseButton.setTitle("Add Expense", for: .normal)
        addExpenseButton.tag = BEExpenseAction.expense.rawValue
        addExpenseButton.addTarget(self, action: #selector(BEHomePageViewController.actionButtonPressed(_:)), for: .touchUpInside)

        let addIncomeButton = UIButton(type: .custom)
        addIncomeButton.setTitleColor(UIColor.blue, for: .normal)
        addIncomeButton.setTitle("Add Income", for: .normal)
        addIncomeButton.tag = BEExpenseAction.income.rawValue
        addIncomeButton.addTarget(self, action: #selector(BEHomePageViewController.actionButtonPressed(_:)), for: .touchUpInside)

        // Stackviews
        let buttonsStackview = UIStackView(arrangedSubviews: [addIncomeButton, addExpenseButton])
        buttonsStackview.alignment = UIStackViewAlignment.fill
        buttonsStackview.distribution = UIStackViewDistribution.fillEqually
        buttonsStackview.axis = .horizontal

        // Generic stackView
        let genericStackView = UIStackView(arrangedSubviews: [amountLabel, buttonsStackview])
        genericStackView.translatesAutoresizingMaskIntoConstraints = false
        genericStackView.axis = .vertical
        genericStackView.distribution = .fillProportionally

        self.view.addSubview(genericStackView)

        genericStackView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        genericStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        genericStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        genericStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// This method calls the next viewController for handle data input from the user.
    /// The tag of a button is synced with expense/income.
    ///
    /// - parameter sender: the button sending the event
    @objc fileprivate func actionButtonPressed(_ sender: AnyObject) {
        guard let button = sender as? UIButton,
            let expenseAction = BEExpenseAction(rawValue: button.tag) else {
            return
        }
        let addDataViewController = BEAddDataViewController(with: expenseAction)
        self.present(addDataViewController, animated: true, completion: nil)
    }
}

