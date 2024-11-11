//
//  ContinueButton.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct ContinueButton: View {
    @Binding var enabled: Bool
    var onTap: (() -> Void)

    var body: some View {
        Button("Continue") {
            onTap()
        }
        .padding(.top, 20)
        .buttonStyle(ShrinkingButton())
        .disabled(!enabled)
    }
}

#Preview {
    ContinueButton(
        enabled: .constant(true),
        onTap: { print("handle on tap") }
    )
}
