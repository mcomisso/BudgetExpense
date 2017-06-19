//
//  BETheme.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import UIKit
import Material

struct BETheme {
    struct Colors {
        static let darkPrimary = Color.teal.darken1
        static let primary = Color.teal.base
        static let lightPrimary = Color.teal.lighten1
        static let textIcons = Color.grey.lighten5
        static let accent = Color.red.base
        static let primaryText = Color.darkText.primary
        static let secondaryText = Color.darkText.secondary
        static let divider = Color.grey.lighten1

        static let income = Color.teal.base
        static let expense = Color.red.base
    }
}


//
//  ThemeManager.swift
//  Cryptospace
//
//  Created by Matteo Comisso on 30/03/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//
struct BEColorPalette {
    let backgroundColor: UIColor
    let whiteText: UIColor
    let blueText: UIColor
    let accentLight: UIColor
    let accentDark: UIColor
    let navigationBarTint: UIColor

    fileprivate func toDict() -> NSDictionary {
        return NSDictionary(dictionary: ["backgroundColor": NSKeyedArchiver.archivedData(withRootObject: backgroundColor),
                                         "whiteText": NSKeyedArchiver.archivedData(withRootObject: whiteText),
                                         "blueText": NSKeyedArchiver.archivedData(withRootObject: blueText),
                                         "accentLight": NSKeyedArchiver.archivedData(withRootObject: accentLight),
                                         "accentDark": NSKeyedArchiver.archivedData(withRootObject: accentDark),
                                         "navigationBarTint": NSKeyedArchiver.archivedData(withRootObject: navigationBarTint)])
    }
}

protocol Themable {
    func loadTheme()
}

final class BEThemeManager {
    public enum Theme: String {
        case dark, light

        var color: BEColorPalette {
            get {
                switch self {
                case .dark:
                    let backgroundColor = "1E324A"
                    let whiteText = "FEFEFE"
                    let blueText = "A5C9E1"
                    let accentLight = "71B1CA"
                    let accentDark = "2E7A96"
                    let navigationBarTint = "0B3E5F"

                    return BEColorPalette(backgroundColor: UIColor(hex: backgroundColor),
                                          whiteText: UIColor(hex: whiteText),
                                          blueText: UIColor(hex: blueText),
                                          accentLight: UIColor(hex: accentLight),
                                          accentDark: UIColor(hex: accentDark),
                                          navigationBarTint: UIColor(hex: navigationBarTint))

                case .light:
                    let backgroundColor = Color.blueGrey.darken3
                    let whiteText = Color.lightText.primary
                    let blueText = Color.darkText.primary
                    let accentLight = Color.deepOrange.accent1
                    let accentDark = Color.deepOrange.darken3
                    let navigationBarTint = Color.deepOrange.base

                    return BEColorPalette(backgroundColor: backgroundColor,
                                          whiteText: whiteText,
                                          blueText: blueText,
                                          accentLight: accentLight,
                                          accentDark: accentDark,
                                          navigationBarTint: navigationBarTint)
                }
            }
        }

        func encode() -> Data {
            return NSKeyedArchiver.archivedData(withRootObject: self.color.toDict())
        }
    }

    static func currentTheme() -> Theme {
        guard let value = UserDefaults.standard.object(forKey: "") as? String,
            let theme = Theme(rawValue: value) else {
                return Theme.dark
        }
        return theme
    }



    static func applyTheme(theme: Theme) {

        let proxyButton = UIButton.appearance()
        proxyButton.tintColor = theme.color.whiteText
        proxyButton.setTitleColor(theme.color.whiteText, for: .normal)
        proxyButton.setTitleColor(theme.color.accentLight, for: .selected)

        let proxyNavigationBar = UINavigationBar.appearance()
        proxyNavigationBar.barTintColor = theme.color.navigationBarTint
        proxyNavigationBar.barStyle = .black
        proxyNavigationBar.tintColor = theme.color.whiteText

        let proxyLabel = UILabel.appearance(whenContainedInInstancesOf: [UICollectionViewCell.self])
//        proxyLabel.font =  R.font.ralewayBlack(size: 12)
        proxyLabel.textColor = theme.color.whiteText
        
//        UserDefaults.standard.set(theme.rawValue, forKey: Constants.Strings.currentTheme)
        UserDefaults.standard.synchronize()
    }
    
}
