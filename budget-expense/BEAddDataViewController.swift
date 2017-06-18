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
import SQFeedbackGenerator
import Presentr

enum BEAddDataType {
    case expense, income
}

protocol BEAddDataViewControllerPresenterDelegate: class {
    func didPressDateSelection(_ addDataViewController: BEAddDataViewController)
}

final class BEAddDataViewController: UIViewController {

    // DELEGATE
    weak var delegate: BEAddDataViewControllerPresenterDelegate?

    // Public
    public var type: BEAddDataType = .expense

    @IBOutlet var buttons: [Button]! // Array containing all digits buttons

    @IBOutlet weak var cardContainer: Card!

    @IBOutlet weak var sideDeleteButton: UIButton!
    @IBOutlet weak var saveButton: RaisedButton! // Delete digit button

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateButton: FlatButton!

    @IBOutlet weak var notesTextField: TextField!

    @IBOutlet weak var actionsStackView: UIStackView!


    private lazy var currentDigits: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 80)
        label.sizeToFit()
        label.text = NSNumber.init(value: 0.00).toCurrency()

        return label
    }()



    // Small view controller that contains all the categories
    var categoriesVC: BECategoriesCollectionView!

    var bottomHalfPresentr: Presentr {
        let p = Presentr(presentationType: .bottomHalf)
        p.blurBackground = true
        p.blurStyle = .regular

        return p
    }


    fileprivate lazy var oneThirdPresentr: Presentr = { [weak self] in
        guard let strongSelf = self else { fatalError() }
        let height = ModalSize.fluid(percentage: 1/3)

        let p = Presentr(presentationType: .custom(width: ModalSize.full, height: height, center: .bottomCenter))
        p.blurStyle = .regular
        p.blurBackground = true
        return p
    }()

    let feedbackGenerator = SQFeedbackGenerator()

    fileprivate lazy var dismissAnimator: BETransitioningDismissingAnimator = { [weak self] in
        guard let `self` = self else { fatalError() }
        return BETransitioningDismissingAnimator(direction: self.type == .expense ? .down : .up)
        }()

    fileprivate var numericMem = NumericMem() {
        didSet {
            self.currentDigits.text = self.numericMem.toNumber().toCurrency()
        }
    }

    fileprivate var date: Date = Date() {
        didSet {
            BEUtils.longDateFormatter.string(from: self.date)

            var titleButton = ""
            if date.isToday {
                titleButton = "Today"
            } else if date.isYesterday {
                titleButton = "Yesterday"
            } else {
                titleButton = "\(self.date.day)/\(self.date.month)\n\(self.date.year)"
            }
            self.dateButton.setTitle(titleButton, for: .normal)
        }
    }

    //MARK: VIEW LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate method to set the textField
        self.notesTextField.textColor = BETheme.Colors.textIcons
        self.notesTextField.delegate = self

        self.notesTextField.dividerActiveColor = .white
        self.notesTextField.detailColor = .white
        self.notesTextField.placeholderActiveColor = .white

        self.dateLabel.textColor = BETheme.Colors.textIcons
        self.dateLabel.text = BEUtils.longDateFormatter.string(from: self.date)

        self.dateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.dateButton.titleLabel?.minimumScaleFactor = 0.5
        self.dateButton.titleLabel?.numberOfLines = 2
        self.dateButton.titleLabel?.textAlignment = .center
        self.dateButton.setTitleColor(.white, for: .normal)

        self.setCurrentType()

        self.setupButtons()

        self.setupActionButtons()

        self.setupDigits()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK:-

    func setupDigits() {
        self.cardContainer.depth = Depth(offset: Offset.init(horizontal: 0, vertical: 4), opacity: 0.2, radius: 10)
        self.cardContainer.contentView = self.currentDigits
        self.cardContainer.cornerRadius = 15
        if self.type == .expense {
            self.cardContainer.container.gradientFromColor(BETheme.Colors.expense)
        } else {
            self.cardContainer.container.gradientFromColor(BETheme.Colors.income)
        }
    }


    /// Set the current screen type (expense or income)
    func setCurrentType() {

        self.view.backgroundColor = Color.blueGrey.base

//        switch self.type {
//        case .income:
//            self.view.gradientFromColor(BETheme.Colors.primary)
//            self.view.backgroundColor = .clear
//            self.notesTextField.detailColor = Color.teal.accent3
//        case .expense:
//            self.view.gradientFromColor(Color.deepOrange.base)
//            self.view.backgroundColor = .clear
//            self.notesTextField.detailColor = Color.red.accent3
//        }
    }

    func setupActionButtons() {
        self.saveButton.setTitle("", for: .normal)
        self.saveButton.setImage(Icon.cm.check, for: .normal)

        var locationButton: IconButton? = nil

        if BESettings.automaticGeolocation.boolValue {
            locationButton = IconButton(image: Icon.place)
            locationButton?.tintColor = .white
            locationButton?.addTarget(self, action: #selector(self.didPressLocation), for: .touchUpInside)
        }


        if self.type == .expense {
            self.saveButton.titleColor = BETheme.Colors.expense
        } else {
            self.saveButton.titleColor = BETheme.Colors.income
        }

        let pictureButton = IconButton(image: Icon.photoCamera)

        pictureButton.tintColor = .white

        if let location = locationButton {
            self.actionsStackView.addArrangedSubview(location)
        }

        self.actionsStackView.addArrangedSubview(pictureButton)

        pictureButton.addTarget(self, action: #selector(self.didPressPicture), for: .touchUpInside)
    }

    func didPressLocation() {
        // ASK LOCATION MANAGER TO FETCH
        BELocationManager.shared.requestLocation()
    }

    func didPressPicture() {
        let actionSheet = UIAlertController(title: "Choose a source", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            // Select from gallery
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            // Select from Camera
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }

    func setupButtons() {

        self.sideDeleteButton.setTitle("", for: .normal)
        self.sideDeleteButton.setImage(#imageLiteral(resourceName: "delete").tint(with: .white), for: .normal)
        self.sideDeleteButton.imageView?.contentMode = .scaleAspectFit
        self.sideDeleteButton.addTarget(self, action: #selector(self.deleteLastDigit(_:)), for: .touchUpInside)
        self.sideDeleteButton.addTarget(self, action: #selector(feedbackForPressDigit(sender:)), for: .touchDown)

        for button in self.buttons {
            button.setTitleColor(BETheme.Colors.textIcons, for: .normal)
            button.addTarget(self, action: #selector(didPressDigit(sender:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(feedbackForPressDigit(sender:)), for: .touchDown)

            let attributedString = NSMutableAttributedString(string: (button.titleLabel?.text)!)
            attributedString.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 22)], range: NSMakeRange(0, attributedString.string.characters.count))
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }


    func feedbackForPressDigit(sender: Button) {
        self.feedbackGenerator.generateFeedback(type: .notification)
        BESoundPlayer.play(sound: .click)
    }

    func didPressDigit(sender: Button) {
        if self.buttons.contains(sender) {
            self.numericMem.addDigit(digit: (sender.titleLabel?.text)!)
        }
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

//        BECloudKitManager.shared.save(amount: amount, type: self.type, notes: self.notesTextField.text!, date: Date())
        BERealmManager.shared.save(amount: amount, type: self.type, notes: self.notesTextField.text!, date: self.date)

        self.transitioningDelegate = self
        self.dismiss(animated: true) { 
            // Display success
            self.feedbackGenerator.generateFeedback(type: .success, completion: { 
                BESoundPlayer.play(sound: .beepOn)
            })
        }
    }

    @IBAction func setDate(_ sender: Any) {

        // ViewController with dateSelection
        guard let datePicker = R.storyboard.main.datePickerViewController() else { return }
        datePicker.delegate = self
        datePicker.setDate(date: self.date)
        self.customPresentViewController(self.oneThirdPresentr, viewController: datePicker, animated: true, completion: nil)
    }

}

extension BEAddDataViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}

extension BEAddDataViewController: BECategoriesCollectionViewControllerDelegate {

    func didSelectAddCategory() {

        // Category CreationVC

        let categorySelector = R.storyboard.categories().instantiateInitialViewController() as! BECategorySelectorViewController

        self.customPresentViewController(self.bottomHalfPresentr, viewController: categorySelector, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.bEAddDataViewController.embeddedCategoriesSegue.identifier {
            self.categoriesVC = segue.destination as! BECategoriesCollectionView
            self.categoriesVC.delegate = self
        }
    }

}

extension BEAddDataViewController {

    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissAnimator
    }
}

extension BEAddDataViewController: BEDateSelectorViewControllerDelegate {
    func didSelectDate(_ dateSelectorViewController: BEDateSelectorViewController, date: Date) {
        self.updateDates(date: date)
    }

    func updateDates(date: Date) {
        self.date = date
        let dateLabel = UILabel()
        dateLabel.text = BEUtils.longDateFormatter.string(from: self.date)
        self.cardContainer.bottomBar = Bar.init(centerViews: [dateLabel])
    }
}

