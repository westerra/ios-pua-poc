//
//  ShrinkingButton.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct ShrinkingButton: ButtonStyle {
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(isEnabled ? Color.appTheme : Color.appThemeDisabled)
            .foregroundColor(.textPrimaryReversed)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ShrinkingButtonWhite: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .font(.system(size: 16, weight: .bold))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .overlay(Capsule().stroke(.black, lineWidth: 1))
    }
}
