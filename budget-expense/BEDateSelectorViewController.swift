//
//  BEDateSelectorViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 18/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit

protocol BEDateSelectorViewControllerDelegate: class {
    func didSelectDate(_ dateSelectorViewController: BEDateSelectorViewController, date: Date)
}

final class BEDateSelectorViewController: UIViewController {


    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: BEDateSelectorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveDate(_ sender: Any) {
        self.delegate?.didSelectDate(self, date: self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }

}
