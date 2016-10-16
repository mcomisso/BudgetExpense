//
//  FirstViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit

enum ContinueCases: String {
    case comma = ","
    case save = "Save"
    case doubleZero = "00"
}

class BEAddDataViewController: UIViewController {

    var memory: String = ""

    @IBOutlet weak var currentDigits: UILabel!

    // Array containing all digits buttons
    @IBOutlet var buttons: [UIButton]!

    // Comma and save button
    @IBOutlet weak var genericConfirmationButton: UIButton!

    // Delete digit button
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.currentDigits.text = String(memory)

        for button in self.buttons {
            button.addTarget(self, action: #selector(didPressDigit(sender:)), for: .touchUpInside)
        }


        let closegesture = UITapGestureRecognizer(target: self, action: #selector(closeViewController))
        closegesture.delegate = self
        closegesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(closegesture)

        self.genericConfirmationButton.addTarget(self, action: #selector(addCommaOrContinue), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(deleteText), for: .touchUpInside)
    }

    func didPressDigit(sender: UIButton) {
        if self.buttons.contains(sender) {
            self.memory.append((sender.titleLabel?.text?.characters.first)!)
            self.currentDigits.text = memory
        }
    }

    func addCommaOrContinue() {
        guard let textCheck = self.currentDigits.text else {
            return
        }

        if !textCheck.contains(",") {
            self.memory.append(",")
            self.currentDigits.text = self.memory
            self.genericConfirmationButton.setTitle("Save", for: .normal)
        } else if textCheck.contains(",") && self.genericConfirmationButton.titleLabel?.text == "Save" {
            let amount = Double(self.memory.replacingOccurrences(of: ",", with: "."))
            BERealmManager.shared.saveAmount(amount: amount!)
        }
    }

    func deleteText() {
        let character = self.memory.characters.last
        if character == "," {
            self.genericConfirmationButton.setTitle(",", for: .normal)
        }
        self.memory.remove(at: self.memory.index(before: self.memory.endIndex))
        self.currentDigits.text = self.memory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BEAddDataViewController: UIGestureRecognizerDelegate {
    func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
