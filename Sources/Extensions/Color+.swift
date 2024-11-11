//
//  Color+.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import SwiftUI
import UIKit

extension Color {

    static let aquaDark = Color("aquaDark")
    static let aquaDarkest = Color("aquaDarkest")
    static let aquaLight = Color("aquaLight")
    static let aquaLightest = Color("aquaLightest")
    static let aquaPrimary = Color("aquaPrimary")
    static let contentBackground = Color("contentBackground")
    static let dark = Color("dark")
    static let borderColor = Color("borderColor")
    static let primaryGreen = Color("primaryGreen")
    static let greyDark = Color("greyDark")
    static let greyDarkest = Color("greyDarkest")
    static let greyLight = Color("greyLight")
    static let greyLightest = Color("greyLightest")
    static let redDark = Color("redDark")
    static let redDarkest = Color("redDarkest")
    static let redLight = Color("redLight")
    static let redLightest = Color("redLightest")
    static let redMedium = Color("redMedium")
    static let redPrimary = Color("redPrimary")
    static let redPrimaryBackground = Color("redPrimaryBackground")

    static let appTheme = Color(UIColor.appTheme)
    static let appThemeDisabled = Color(UIColor.appThemeDisabled)
    static let appBackground = Color(UIColor.appBackground)
    static let textPrimary = Color(UIColor.textPrimary)
    static let textPrimaryReversed = Color(UIColor.textPrimaryReversed)

    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension UIColor {

    // Disabling force_unwrapping check because we should have the assets to back these variables
    // swiftlint:disable force_unwrapping
    static let textPrimary = UIColor(light: .dark, dark: .white)
    static let textPrimaryReversed = UIColor(light: .white, dark: .dark)

    static let aquaDark = UIColor(named: "aquaDark")!
    static let aquaDarkest = UIColor(named: "aquaDarkest")!
    static let aquaLight = UIColor(named: "aquaLight")!
    static let aquaLightest = UIColor(named: "aquaLightest")!
    static let aquaPrimary = UIColor(named: "aquaPrimary")!
    static let contentBackground = UIColor(named: "contentBackground")!
    static let dark = UIColor(named: "dark")!
    static let borderColor = UIColor(named: "borderColor")!
    static let primaryGreen = UIColor(named: "primaryGreen")!
    static let greyDark = UIColor(named: "greyDark")!
    static let greyDarkest = UIColor(named: "greyDarkest")!
    static let greyLight = UIColor(named: "greyLight")!
    static let greyLightest = UIColor(named: "greyLightest")!
    static let redDark = UIColor(named: "redDark")!
    static let redDarkest = UIColor(named: "redDarkest")!
    static let redLight = UIColor(named: "redLight")!
    static let redLightest = UIColor(named: "redLightest")!
    static let redMedium = UIColor(named: "redMedium")!
    static let redPrimary = UIColor(named: "redPrimary")!
    static let redPrimaryBackground = UIColor(named: "redPrimaryBackground")!

    static let appTheme = UIColor(light: .redPrimary, dark: .aquaPrimary)
    static let appThemeDisabled = UIColor(light: .redLight, dark: .greyLight)
    static let appBackground = UIColor(light: .greyLightest, dark: .dark)
    // swiftlint:enable force_unwrapping
}
