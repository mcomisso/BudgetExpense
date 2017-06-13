//
//  FirstViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 02/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//
import Foundation
import UIKit
import Material

enum BEAddDataType {
    case expense, income
}

class Stack<T: CustomStringConvertible> {
    private var basemem = [T]()

    func addElement(element: T) {
        self.basemem.append(element)
    }

    func removeElement() {
        if self.basemem.isEmpty == false {
            self.basemem.removeLast()
        }
    }

    func toDecimal() -> Double {
        if basemem.isEmpty {
            return 0.00
        }
        guard let retVal = Double(basemem.map{ $0.description }.joined()) else { fatalError() }
        return retVal / 100.0
    }
}


struct NumericMem {

    var numberStack = Stack<String>()

    func toNumber() -> NSNumber {
        return NSNumber(value: self.toDouble())
    }

    func toDouble() -> Double {
        return self.numberStack.toDecimal()
    }

    mutating func addDigit(digit: String) {
        let characters = digit.characters.map { String($0) }

        for char in characters {
            self.numberStack.addElement(element: char)
        }
    }

    mutating func removeDigit() {
        self.numberStack.removeElement()
    }
}



class BEAddDataViewController: UIViewController {

    // Public
    public var type: BEAddDataType = .expense

    fileprivate lazy var dismissAnimator: BETransitioningDismissingAnimator = { [weak self] in
        guard let `self` = self else { fatalError() }
        return BETransitioningDismissingAnimator(direction: self.type == .expense ? .down : .up)
    }()

    fileprivate var numericMem = NumericMem() {
        didSet {
            self.currentDigits.text = BEUtils.formatNumberToCurrency(number: self.numericMem.toNumber())
        }
    }

    @IBOutlet var buttons: [Button]! // Array containing all digits buttons
    @IBOutlet weak var currentDigits: UILabel!
    @IBOutlet weak var deleteButton: UIButton! // Delete digit button

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var notesTextField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate method to set the textField
        self.notesTextField.textColor = BETheme.Colors.textIcons
        self.notesTextField.delegate = self

        self.dateLabel.textColor = BETheme.Colors.textIcons

        self.setCurrentType()
        self.setupButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setCurrentType() {
        switch self.type {
        case .income:
            self.view.backgroundColor = BETheme.Colors.primary
            self.notesTextField.detailColor = Color.teal.accent3
        case .expense:
            self.view.backgroundColor = BETheme.Colors.accent
            self.notesTextField.detailColor = Color.red.accent3
        }
    }

    func setupButtons() {
        for button in self.buttons {
            button.setTitleColor(BETheme.Colors.textIcons, for: .normal)
            button.addTarget(self, action: #selector(didPressDigit(sender:)), for: .touchUpInside)

            let attributedString = NSMutableAttributedString(string: (button.titleLabel?.text)!)
            attributedString.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 22)], range: NSMakeRange(0, attributedString.string.characters.count))
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }

    func didPressDigit(sender: Button) {
        var feedbackGenerator: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()

        if self.buttons.contains(sender) {
            feedbackGenerator?.selectionChanged()
            self.numericMem.addDigit(digit: (sender.titleLabel?.text)!)
        }
        feedbackGenerator = nil
    }

    @IBAction func deleteLastDigit(_ sender: AnyObject) {
        self.numericMem.removeDigit()
    }


    // MARK: - IBActions
    @IBAction func close(_ sender: AnyObject) {
        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAmount(_ sender: AnyObject) {
        let amount = self.numericMem.toDouble()

        BECloudKitManager.shared.save(amount: amount, type: self.type, notes: self.notesTextField.text!, date: Date())
        BERealmManager.shared.save(amount: amount, type: self.type, notes: self.notesTextField.text!, date: Date())

        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: nil)
    }
}

extension BEAddDataViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}


extension BEAddDataViewController {

    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissAnimator
    }
}
