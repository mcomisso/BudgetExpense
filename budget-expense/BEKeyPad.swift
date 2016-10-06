//
//  ESKeyPad.swift
//  budget-expense
//
//  Created by Matteo Comisso on 04/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import UIKit

protocol BEKeyPadDelegate {

    func didTapButton()
}

class BEKeyPad: UIView {
    fileprivate var firstVertical: UIStackView? = nil
    fileprivate var secondVertical: UIStackView? = nil
    fileprivate var thirdVertical: UIStackView? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        var numbers = [UIButton]()

        for i in 0..<10 {
            let button = UIButton(type: .custom)
            button.setTitle("\(i)", for: .normal)
            button.tag = i
            button.titleLabel?.textAlignment = .center

            numbers.append(button)
        }

        self.firstVertical  = UIStackView(arrangedSubviews: [numbers[1], numbers[4], numbers[7]])
        self.secondVertical = UIStackView(arrangedSubviews: [numbers[2], numbers[5], numbers[8]])
        self.thirdVertical  = UIStackView(arrangedSubviews: [numbers[3], numbers[6], numbers[9]])

        guard let first = self.firstVertical,
            let second = self.secondVertical,
            let third = self.thirdVertical else {
                fatalError("Errors")
        }

        first.axis = .vertical
        first.alignment = .center

        second.axis = .vertical
        second.alignment = .center

        third.axis = .vertical
        third.alignment = .center

        let horizontalStackView = UIStackView(arrangedSubviews: [first, second, third])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center

        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalStackView)

        //  Horizontal
        horizontalStackView.widthAnchor.constraint(equalTo: horizontalStackView.heightAnchor).isActive = true

        horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
