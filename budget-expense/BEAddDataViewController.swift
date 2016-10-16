//
//  FirstViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit

enum BEAddDataType {
    case expense, income
}

class BEAddDataViewController: UIViewController {

    // Public
    public var type: BEAddDataType = .expense

    fileprivate var memory: String = "0,00" {
        didSet {
            self.currentDigits.text = self.memory
        }
    }

    @IBOutlet var buttons: [UIButton]! // Array containing all digits buttons
    @IBOutlet weak var currentDigits: UILabel!
    @IBOutlet weak var deleteButton: UIButton! // Delete digit button

    @IBOutlet weak var dateLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        switch self.type {
        case .income:
            self.view.backgroundColor = BETheme.Colors.primary
        case .expense:
            self.view.backgroundColor = BETheme.Colors.accent
        }

        self.dateLabel.textColor = BETheme.Colors.textIcons

        self.setupButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupButtons() {
        for button in self.buttons {

            button.setTitleColor(BETheme.Colors.textIcons, for: .normal)
            button.addTarget(self, action: #selector(didPressDigit(sender:)), for: .touchUpInside)

            let attributedString = NSMutableAttributedString(string: (button.titleLabel?.text)!)
            attributedString.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 30)], range: NSMakeRange(0, attributedString.string.characters.count))
            button.setAttributedTitle(attributedString, for: .highlighted)

            attributedString.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 22)], range: NSMakeRange(0, attributedString.string.characters.count))
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }

    func didPressDigit(sender: UIButton) {
        if self.buttons.contains(sender) {
            self.memory.append((sender.titleLabel?.text?.characters.first)!)
        }
    }

    @IBAction func deleteLastDigit(_ sender: AnyObject) {
        self.memory.remove(at: self.memory.index(before: self.memory.endIndex))
    }


    // MARK: - IBActions
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAmount(_ sender: AnyObject) {
        let amount = Double(self.memory.replacingOccurrences(of: ",", with: "."))
        BERealmManager.shared.saveAmount(amount: amount!, type: self.type)
        self.dismiss(animated: true, completion: nil)
    }
}
