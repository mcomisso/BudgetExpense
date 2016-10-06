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
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.white, for: .normal)

        let save = UIButton(type: .custom)
        save.addTarget(self, action: #selector(BEAddDataViewController.save), for: .touchUpInside)
        save.setTitle("Save", for: .normal)
        save.setTitleColor(.white, for: .normal)

        // Buttons [Cancel] [Save]
        let buttonStack = UIStackView(arrangedSubviews: [cancel, save])
        buttonStack.alignment = .center
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        // add a textfield for adding properties
        let dataInput = UITextField()
        dataInput.placeholder = "0.00"
        dataInput.font = UIFont.systemFont(ofSize: 32.0)
        dataInput.sizeToFit()

        let keypad = BEKeyPad(frame: CGRect.zero)

        // ViewController
        let viewControllerStack = UIStackView(arrangedSubviews: [buttonStack, dataInput, keypad])
        viewControllerStack.axis = .vertical
        viewControllerStack.alignment = .fill
        viewControllerStack.translatesAutoresizingMaskIntoConstraints = false

        // Add to view controller
        self.view.addSubview(viewControllerStack)

        // UIViewController stack
        viewControllerStack.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        viewControllerStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        viewControllerStack.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        viewControllerStack.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
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

