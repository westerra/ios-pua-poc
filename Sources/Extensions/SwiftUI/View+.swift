//
//  View+.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }

    func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat = 10) -> some View where S: ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top:
                return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))

            case .bottom:
                return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))

            case .leading:
                return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))

            case .trailing:
                return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }
        .reduce(into: Path()) { $0.addPath($1) }
    }
}
