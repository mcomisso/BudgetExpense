//
//  InterfaceController.swift
//  watchKit Extension
//
//  Created by Matteo Comisso on 21/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var groupOfPickers: WKInterfaceGroup!

    @IBOutlet var pickerObject: WKInterfacePicker!
    @IBOutlet var picker2: WKInterfacePicker!
    @IBOutlet var picker3: WKInterfacePicker!
    @IBOutlet var picker4: WKInterfacePicker!
    @IBOutlet var picker5: WKInterfacePicker!

    @IBOutlet var didSwipeLeftGR: WKSwipeGestureRecognizer!
    @IBOutlet var didSwipeRightGR: WKSwipeGestureRecognizer!

    private lazy var pickers: [WKInterfacePicker] = { [weak self] in
        guard let `self` = self else { fatalError() }
        return [self.pickerObject, self.picker2, self.picker3, self.picker4, self.picker5]
    }()

    private var numbers: [WKPickerItem] = [0, 1,2,3,4,5,6,7,8,9].map { digit in
        let wkPicker = WKPickerItem()
        wkPicker.title = String(digit)
        return wkPicker
    }


    private var pickersCollection: [WKInterfacePicker] = []


    @IBAction func didSwipeLeft(_ sender: Any) {

        // Hide / remove digit

        print("Did swipe from left")
    }


    @IBAction func didSwipeRight(_ sender: Any) {

        // Append (make visible a new picker

        print("Did swipe from right")

    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.

        self.pickersCollection = [pickerObject, picker2, picker3, picker4, picker5]

        self.pickersCollection.forEach {
            $0.setItems(self.numbers)
            
            if self.pickersCollection.first != $0 {
                $0.setHidden(true)
            }
        }


    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        self.pickerObject.focus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
