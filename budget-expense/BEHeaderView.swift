//
//  BEHeaderView.swift
//  budget-expense
//
//  Created by Matteo Comisso on 13/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

class BEHeaderView: UICollectionReusableView {

    @IBOutlet weak var dateHeader: UILabel!
    @IBOutlet weak var dateSubHeader: UILabel!

    static let reuseIdentifier = "BEHeaderViewReuseIdentifier"

    var day: Date? {
        didSet {
            guard let day = self.day else { return }
            self.dateHeader.text = BEUtils().longDateFormatter.string(from: day)
            self.dateSubHeader.text = BEUtils().dateFormatter.string(from: day)
        }
    }

    func setDay(date: Date) {
        self.day = date
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.day = nil
        self.dateHeader.text = nil
        self.dateSubHeader.text = nil
    }
}
