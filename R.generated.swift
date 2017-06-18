//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 4 files.
  struct file {
    /// Resource file `Pods-budget-expense-acknowledgements.plist`.
    static let podsBudgetExpenseAcknowledgementsPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "Pods-budget-expense-acknowledgements", pathExtension: "plist")
    /// Resource file `beep_short_off.aif`.
    static let beep_short_offAif = Rswift.FileResource(bundle: R.hostingBundle, name: "beep_short_off", pathExtension: "aif")
    /// Resource file `beep_short_on.aif`.
    static let beep_short_onAif = Rswift.FileResource(bundle: R.hostingBundle, name: "beep_short_on", pathExtension: "aif")
    /// Resource file `click.aif`.
    static let clickAif = Rswift.FileResource(bundle: R.hostingBundle, name: "click", pathExtension: "aif")
    
    /// `bundle.url(forResource: "Pods-budget-expense-acknowledgements", withExtension: "plist")`
    static func podsBudgetExpenseAcknowledgementsPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.podsBudgetExpenseAcknowledgementsPlist
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "beep_short_off", withExtension: "aif")`
    static func beep_short_offAif(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.beep_short_offAif
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "beep_short_on", withExtension: "aif")`
    static func beep_short_onAif(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.beep_short_onAif
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "click", withExtension: "aif")`
    static func clickAif(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.clickAif
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 7 images.
  struct image {
    /// Image `add`.
    static let add = Rswift.ImageResource(bundle: R.hostingBundle, name: "add")
    /// Image `cloud`.
    static let cloud = Rswift.ImageResource(bundle: R.hostingBundle, name: "cloud")
    /// Image `delete`.
    static let delete = Rswift.ImageResource(bundle: R.hostingBundle, name: "delete")
    /// Image `key`.
    static let key = Rswift.ImageResource(bundle: R.hostingBundle, name: "key")
    /// Image `location`.
    static let location = Rswift.ImageResource(bundle: R.hostingBundle, name: "location")
    /// Image `stats`.
    static let stats = Rswift.ImageResource(bundle: R.hostingBundle, name: "stats")
    /// Image `sync`.
    static let sync = Rswift.ImageResource(bundle: R.hostingBundle, name: "sync")
    
    /// `UIImage(named: "add", bundle: ..., traitCollection: ...)`
    static func add(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.add, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "cloud", bundle: ..., traitCollection: ...)`
    static func cloud(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cloud, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "delete", bundle: ..., traitCollection: ...)`
    static func delete(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.delete, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "key", bundle: ..., traitCollection: ...)`
    static func key(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.key, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "location", bundle: ..., traitCollection: ...)`
    static func location(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.location, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "stats", bundle: ..., traitCollection: ...)`
    static func stats(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.stats, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sync", bundle: ..., traitCollection: ...)`
    static func sync(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sync, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 6 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `BEHeaderViewReuseIdentifier`.
    static let bEHeaderViewReuseIdentifier: Rswift.ReuseIdentifier<BEHeaderView> = Rswift.ReuseIdentifier(identifier: "BEHeaderViewReuseIdentifier")
    /// Reuse identifier `ColorReuseIdentifier`.
    static let colorReuseIdentifier: Rswift.ReuseIdentifier<BEColorCell> = Rswift.ReuseIdentifier(identifier: "ColorReuseIdentifier")
    /// Reuse identifier `GliphReuseIdentifier`.
    static let gliphReuseIdentifier: Rswift.ReuseIdentifier<BEGliphCell> = Rswift.ReuseIdentifier(identifier: "GliphReuseIdentifier")
    /// Reuse identifier `categoriesCellIdentifier`.
    static let categoriesCellIdentifier: Rswift.ReuseIdentifier<BECategoryCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "categoriesCellIdentifier")
    /// Reuse identifier `currencyCellReuseIdentifier`.
    static let currencyCellReuseIdentifier: Rswift.ReuseIdentifier<UIKit.UITableViewCell> = Rswift.ReuseIdentifier(identifier: "currencyCellReuseIdentifier")
    /// Reuse identifier `overviewCellIdentifier`.
    static let overviewCellIdentifier: Rswift.ReuseIdentifier<BETransactionCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "overviewCellIdentifier")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 1 view controllers.
  struct segue {
    /// This struct is generated for `BEAddDataViewController`, and contains static references to 1 segues.
    struct bEAddDataViewController {
      /// Segue identifier `EmbeddedCategoriesSegue`.
      static let embeddedCategoriesSegue: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, BEAddDataViewController, BECategoriesCollectionView> = Rswift.StoryboardSegueIdentifier(identifier: "EmbeddedCategoriesSegue")
      
      /// Optionally returns a typed version of segue `EmbeddedCategoriesSegue`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func embeddedCategoriesSegue(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, BEAddDataViewController, BECategoriesCollectionView>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.bEAddDataViewController.embeddedCategoriesSegue, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 6 storyboards.
  struct storyboard {
    /// Storyboard `Categories`.
    static let categories = _R.storyboard.categories()
    /// Storyboard `InitialStartup`.
    static let initialStartup = _R.storyboard.initialStartup()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Settings`.
    static let settings = _R.storyboard.settings()
    /// Storyboard `Transactions`.
    static let transactions = _R.storyboard.transactions()
    
    /// `UIStoryboard(name: "Categories", bundle: ...)`
    static func categories(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.categories)
    }
    
    /// `UIStoryboard(name: "InitialStartup", bundle: ...)`
    static func initialStartup(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.initialStartup)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    /// `UIStoryboard(name: "Settings", bundle: ...)`
    static func settings(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.settings)
    }
    
    /// `UIStoryboard(name: "Transactions", bundle: ...)`
    static func transactions(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.transactions)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try initialStartup.validate()
      try main.validate()
      try transactions.validate()
    }
    
    struct categories: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = BECategorySelectorViewController
      
      let bundle = R.hostingBundle
      let name = "Categories"
      
      fileprivate init() {}
    }
    
    struct initialStartup: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = BEInitialSetupNavigationController
      
      let bundle = R.hostingBundle
      let currencySelectorViewController = StoryboardViewControllerResource<BECurrencySelectorViewController>(identifier: "currencySelectorViewController")
      let name = "InitialStartup"
      let requestController = StoryboardViewControllerResource<BEInitialSetupViewController>(identifier: "requestController")
      
      func currencySelectorViewController(_: Void = ()) -> BECurrencySelectorViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: currencySelectorViewController)
      }
      
      func requestController(_: Void = ()) -> BEInitialSetupViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: requestController)
      }
      
      static func validate() throws {
        if _R.storyboard.initialStartup().currencySelectorViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'currencySelectorViewController' could not be loaded from storyboard 'InitialStartup' as 'BECurrencySelectorViewController'.") }
        if _R.storyboard.initialStartup().requestController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'requestController' could not be loaded from storyboard 'InitialStartup' as 'BEInitialSetupViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = BEHomeViewController
      
      let addDataViewController = StoryboardViewControllerResource<BEAddDataViewController>(identifier: "AddDataViewController")
      let bundle = R.hostingBundle
      let datePickerViewController = StoryboardViewControllerResource<BEDateSelectorViewController>(identifier: "DatePickerViewController")
      let name = "Main"
      
      func addDataViewController(_: Void = ()) -> BEAddDataViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: addDataViewController)
      }
      
      func datePickerViewController(_: Void = ()) -> BEDateSelectorViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: datePickerViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.main().datePickerViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'datePickerViewController' could not be loaded from storyboard 'Main' as 'BEDateSelectorViewController'.") }
        if _R.storyboard.main().addDataViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'addDataViewController' could not be loaded from storyboard 'Main' as 'BEAddDataViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct settings: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Settings"
      
      fileprivate init() {}
    }
    
    struct transactions: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Transactions"
      let transactionsNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "TransactionsNavigationController")
      
      func transactionsNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: transactionsNavigationController)
      }
      
      static func validate() throws {
        if _R.storyboard.transactions().transactionsNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'transactionsNavigationController' could not be loaded from storyboard 'Transactions' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
