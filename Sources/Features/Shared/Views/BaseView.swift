//
//  BaseView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct BaseView<MainContent: View, BottomContent: View>: View {
    private let mainContent: MainContent
    private let bottomContent: BottomContent

    init(
        @ViewBuilder mainContent: () -> MainContent,
        @ViewBuilder bottomContent: () -> BottomContent = { EmptyView() }
    ) {
        self.mainContent = mainContent()
        self.bottomContent = bottomContent()
    }

    var body: some View {
        VStack {
            VStack {
                scrollableContent
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .background(Color.contentBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3.0)

            bottomContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
    }

    var scrollableContent: some View {
        GeometryReader { geometry in
            ScrollView {
                mainContent.frame(minHeight: geometry.size.height)
            }
        }
    }
}

#Preview {
    BaseView(mainContent: { Text("Main Content") })
}
