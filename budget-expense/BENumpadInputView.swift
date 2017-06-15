//
//  BENumpadInputView.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import Material

open class BENumpadInputView: UIView, UIInputViewAudioFeedback {

    private lazy var keyPadView: UIStackView = {

        // The first stack container
        let verticalStackView = UIStackView()

        // Buttons 7 8 9
        let topRow = UIStackView()

        // Buttons 4 5 6
        let midRow = UIStackView()

        // Buttons 1 2 3
        let lowRow = UIStackView()

        let rows = [topRow, midRow, lowRow]

        let row = 0
        for (indexRow, row) in rows.enumerated() {
            for index in 1..<3 {
                let button = Button(title: "\(index * (indexRow + 1))")
                row.addArrangedSubview(button)
            }

        }

        // Finish with translationMask
        for stack in [verticalStackView, topRow, midRow] {
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fillEqually
            stack.axis = .horizontal

        }


        verticalStackView.axis = .vertical
        verticalStackView.addArrangedSubview(topRow)
        verticalStackView.addArrangedSubview(midRow)
        return verticalStackView
    }()

    public var enableInputClicksWhenVisible: Bool {
        return true
    }

    func playClickForTap() {
        UIDevice.current.playInputClick()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.keyPadView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([self.keyPadView.widthAnchor.constraint(equalTo: self.widthAnchor),
                                     self.keyPadView.heightAnchor.constraint(equalTo: self.heightAnchor)])

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Init with aDecoder: Not implemented")
    }
}
