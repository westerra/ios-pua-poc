//
//  LabelDivider.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct LabelDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 10, color: Color = .black) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label)
                .foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack {
            Divider()
                .background(color)
        }
        .padding(horizontalPadding)
    }
}
