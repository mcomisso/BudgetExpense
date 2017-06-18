//
//  BEDateSelectorViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 18/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

protocol BEDateSelectorViewControllerDelegate: class {
    func didSelectDate(_ dateSelectorViewController: BEDateSelectorViewController, date: Date)
}

final class BEDateSelectorViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var dateStringLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: BEDateSelectorViewControllerDelegate?

    fileprivate var date: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateStringLabel.alpha = 0.0
        self.dateStringLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.datePicker.setDate(self.date, animated: false)
    }

    func setDate(date: Date) {
        self.date = date
    }

    @IBAction func goToToday(_ sender: Any) {
        self.datePicker.setDate(Date(), animated: true)
    }

    @IBAction func didChangeDate(_ sender: Any) {

        guard let datePicker = sender as? UIDatePicker else {
            return
        }

        dateStringLabel.layer.removeAllAnimations()

        if datePicker.date.isYesterday {
            self.dateStringLabel.text = "Yesterday"
        } else  if datePicker.date.isToday  {
            self.dateStringLabel.text = "Today"
        } else {
            self.dateStringLabel.text = datePicker.date.weekdayName
        }

        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.dateStringLabel.alpha = 1
        }

        UIView.animate(withDuration: 0.7, delay: 1, options: [], animations: { [weak self] in
            self?.dateStringLabel.alpha = 0.0
        }) { (completed) in
            // Do something?
            self.dateStringLabel.text = nil
        }
    }

    @IBAction func saveDate(_ sender: Any) {
        self.delegate?.didSelectDate(self, date: self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }

}
