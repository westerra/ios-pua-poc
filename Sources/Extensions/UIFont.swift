//
//  UIFont.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import UIKit

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

// https://stackoverflow.com/a/40484460
extension UIFont {

    enum Name: String {
        case black = "CircularXX-Black"
        case blackItalic = "CircularXX-BlackItalic"
        case bold = "CircularXX-Bold"
        case boldItalic = "CircularXX-BoldItalic"
        case book = "CircularXX-Book"
        case bookItalic = "CircularXX-BookItalic"
        case extraBlack = "CircularXX-ExtraBlack"
        case extraBlackItalic = "CircularXX-ExtraBlackItalic"
        case italic = "CircularXX-Italic"
        case light = "CircularXX-Light"
        case lightItalic = "CircularXX-LightItalic"
        case medium = "CircularXX-Medium"
        case mediumItalic = "CircularXX-MediumItalic"
        case regular = "CircularXX-Regular"
        case thin = "CircularXX-Thin"
        case thinItalic = "CircularXX-ThinItalic"
    }

    private(set) static var overrided: Bool = false

    convenience init(name: Name, size: CGFloat) {
        // swiftlint:disable:next force_unwrapping
        self.init(name: name.rawValue, size: size)!
    }

    @objc
    convenience init(ctCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String
        else {
            self.init(ctCoder: aDecoder)
            return
        }

        var fontName = ""

        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = Name.regular.rawValue
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = Name.bold.rawValue
        case "CTFontObliqueUsage":
            fontName = Name.italic.rawValue
        default:
            fontName = Name.regular.rawValue
        }

        // swiftlint:disable:next force_unwrapping
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    static func overrideInitialize(_ design: inout DesignSystem) {
        guard
            self == UIFont.self,
            !overrided
        else {
            return
        }

        // Avoid method swizzling run twice and revert to original initialize function
        overrided = true

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
            let overrideSystemFontMethod = class_getClassMethod(self, #selector(overrideSystemFont(ofSize:weight:))) {
            method_exchangeImplementations(systemFontMethod, overrideSystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let overrideBoldSystemFontMethod = class_getClassMethod(self, #selector(overrideBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, overrideBoldSystemFontMethod)
        }

        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let overrideItalicSystemFontMethod = class_getClassMethod(self, #selector(overrideItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, overrideItalicSystemFontMethod)
        }

        // Trick to get over the lack of UIFont.init(coder:))
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let overrideInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(ctCoder:))) {
            method_exchangeImplementations(initCoderMethod, overrideInitCoderMethod)
        }

        design.fonts.defaultFont = { textStyle, weight in
            return UIFont.preferredFont(for: textStyle, weight: weight)
        }

        design.fonts.preferredFont = { textStyle, weight in
            return UIFont.preferredFont(for: textStyle, weight: weight)
        }
    }

    @objc
    static func overrideSystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .black:                return UIFont(name: .black, size: size)
        case .bold:                 return UIFont(name: .bold, size: size)
        case .light:                return UIFont(name: .light, size: size)
        case .medium:               return UIFont(name: .medium, size: size)
        case .thin:                 return UIFont(name: .thin, size: size)
        default:                    return UIFont(name: .regular, size: size)
        }
    }

    @objc
    static func overrideBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        UIFont(name: .bold, size: size)
    }

    @objc
    static func overrideItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        UIFont(name: .italic, size: size)
    }

    /// Dynamic system font, specifying Style, Weight, and Italics
    /// - Parameters:
    ///   - style: TextStyle for Font
    ///   - weight: Weight of the resulting Font
    ///   - italic: Whether a Font is Italic
    /// - Returns: Adjusted Font
    static func preferredFont(for style: TextStyle, weight: Weight, italic: Bool = false) -> UIFont {

        // Get the style's default pointSize
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traits)

        // Get the font at the default size and preferred weight
        var font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        if italic == true {
            font = font.with([.traitItalic])
        }

        // Setup the font to be auto-scalable
        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }

    private func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
