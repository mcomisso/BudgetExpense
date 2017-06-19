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

    // FEEDBACK
    fileprivate let feedbackGenerator = SQFeedbackGenerator()


    // Public
    public var type: BEAddDataType = .expense



    // INTERFACE BUILDER

    @IBOutlet var buttons: [Button]! // Array containing all digits buttons

    @IBOutlet weak var cardDisplay: BECardDisplay! // Container with current digits (Material card style)

    @IBOutlet weak var sideDeleteButton: UIButton! // Delete last digit button

    @IBOutlet weak var saveButton: RaisedButton! // Delete digit button

    @IBOutlet weak var dateButton: FlatButton! // Date selector button

    @IBOutlet weak var notesTextField: TextField! // Notes text field

    @IBOutlet weak var actionsStackView: UIStackView! // Stackview of buttons (Location and photo capture)


    // Small view controller that contains all the categories
    var categoriesVC: BECategoriesCollectionView!

    // PRESENTERS

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

    fileprivate lazy var dismissAnimator: BETransitioningDismissingAnimator = { [weak self] in
        guard let `self` = self else { fatalError() }
        return BETransitioningDismissingAnimator(direction: self.type == .expense ? .down : .up)
        }()


    // PRIVATE VARS

    fileprivate var selectedCategory: BECategory? {
        didSet {
            self.cardDisplay.category = self.selectedCategory
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

        self.setCurrentType()

        self.setupNumPadButtons()

        self.setupActionButtons()

        self.setupCardContainer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK:-

    func setupCardContainer() {
        self.cardDisplay.prepare(with: self.type, category: self.selectedCategory)
    }


    /// Set the current screen type (expense or income)
    func setCurrentType() {
        self.view.backgroundColor = Color.blueGrey.base

        self.notesTextField.dividerActiveColor = .white
        self.notesTextField.detailColor = .white
        self.notesTextField.placeholderActiveColor = .white
    }

    func setupNumPadButtons() {

        self.dateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.dateButton.titleLabel?.minimumScaleFactor = 0.5
        self.dateButton.titleLabel?.numberOfLines = 2
        self.dateButton.titleLabel?.textAlignment = .center
        self.dateButton.setTitleColor(.white, for: .normal)

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

    func setupActionButtons() {

        // Save button

        self.saveButton.setTitle("", for: .normal)
        if self.type == .expense {
            self.saveButton.setImage(Icon.cm.check?.tint(with: BETheme.Colors.expense), for: .normal)
        } else {
            self.saveButton.setImage(Icon.cm.check?.tint(with: BETheme.Colors.income), for: .normal)
        }

        // Location

        var locationButton: IconButton? = nil

        if BESettings.automaticGeolocation.boolValue {
            locationButton = IconButton(image: Icon.place)
            locationButton?.tintColor = .white
            locationButton?.addTarget(self, action: #selector(self.didPressLocation), for: .touchUpInside)
        }

        if let location = locationButton {
            self.actionsStackView.addArrangedSubview(location)
        }

        // Take picture

        let pictureButton = IconButton(image: Icon.photoCamera)
        pictureButton.tintColor = .white
        pictureButton.addTarget(self, action: #selector(self.didPressPicture), for: .touchUpInside)

        self.actionsStackView.addArrangedSubview(pictureButton)
    }


    //MARK:- Methods

    func didPressLocation() {
        // ASK LOCATION MANAGER TO FETCH
        BELocationManager.shared.requestCurrentLocation()
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


    func feedbackForPressDigit(sender: Button) {
        if BEConstants.Features.HAPTIC_FEEDBACK_ENABLED && BESettings.hapticFeedbackEnabled.boolValue {
            self.feedbackGenerator.generateFeedback(type: .notification)
        }

        if BESettings.appSoundsEnabled.boolValue {
            BESoundPlayer.play(sound: .click)
        }
    }

    func didPressDigit(sender: Button) {
        if self.buttons.contains(sender) {
            self.cardDisplay.addDigit(digit: (sender.titleLabel?.text)!)
        }
    }

    @IBAction func deleteLastDigit(_ sender: AnyObject) {
        self.cardDisplay.deleteDigit()
    }


    // MARK: - IBActions
    @IBAction func close(_ sender: AnyObject) {
        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAmount(_ sender: AnyObject) {
        let amount = self.cardDisplay.getAmount()

//        BECloudKitManager.shared.save(amount: amount, type: self.type, notes: self.notesTextField.text!, date: Date())
        BERealmManager.shared.save(amount: amount, type: self.type, notes: self.notesTextField.text!, date: self.date, category: self.selectedCategory)

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

    /// Triggered when a category is tapped
    ///
    /// - Parameters:
    ///   - categoriesCollectionViewController: The triggering categoriesViewController
    ///   - category: The category selected
    func didSelectCategory(_ categoriesCollectionViewController: BECategoriesCollectionView, category: BECategory) {
        self.selectedCategory = category
        self.cardDisplay.category = category
    }

    func didSelectAddCategory(_ categoriesCollectionViewController: BECategoriesCollectionView) {

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
        self.cardDisplay.bottomBar = Bar.init(centerViews: [dateLabel])
    }
}

