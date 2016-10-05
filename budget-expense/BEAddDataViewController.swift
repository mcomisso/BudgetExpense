//
//  FirstViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit

class BEAddDataViewController: BEViewController {

    var currentOperationMode: BEExpenseAction!

    convenience init(with status: BEExpenseAction) {
        self.init()
        self.currentOperationMode = status

        switch status {
        case .expense:
            // Set the view for expense
            self.view.backgroundColor = UIColor.purple
        case .income:
            self.view.backgroundColor = UIColor.blue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Add a cancel button
        let cancel = UIButton(type: .custom)
        cancel.addTarget(self, action: #selector(BEAddDataViewController.cancel), for: .touchUpInside)

        let save = UIButton(type: .custom)
        save.addTarget(self, action: #selector(BEAddDataViewController.save), for: .touchUpInside)

        // Add a collectionView of categories
        let availableCategories = UICollectionView()

        // add a textfield for adding properties
        let dataInput = UITextField(frame: CGRect.zero)
        dataInput.placeholder = "0.00"
    }

    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    func save() {
        // Save all to realm
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func switchMode() {
        self.currentOperationMode = currentOperationMode == .expense ? .income : .expense
    }


}

