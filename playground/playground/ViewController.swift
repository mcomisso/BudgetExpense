//
//  ViewController.swift
//  playground
//
//  Created by Matteo Comisso on 13/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var label: UILabel = {
        let l = UILabel(frame: .zero)
        l.text = "Ok"
        l.sizeToFit()
        l.translatesAutoresizingMaskIntoConstraints = false

        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.addSubview(self.label)

        self.label.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.label.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }



    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let touch = touches.first {
            self.label.text = String(describing: touch.force)

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

