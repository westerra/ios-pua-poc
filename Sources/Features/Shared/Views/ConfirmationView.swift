//
//  ConfirmationView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

enum ConfirmationState {
    case loading
    case success
    case failure
}

struct ConfirmationView: View {
    @Binding var state: ConfirmationState
    @Binding var errorMessage: String
    var showAddMoreProducts = false
    var onDoneTap: (() -> Void)

    var body: some View {
        VStack {
            switch state {
            case .loading:
                loadingView
            case .success:
                successView
            case .failure:
                failureView
            }
        }
        .padding()
    }
}

extension ConfirmationView {
    var loadingView: some View {
        Group {
            ProgressView {
                Text("Creating Account")
                    .foregroundColor(.appTheme)
                    .bold()
                    .scaleEffect(0.5)
            }
            .scaleEffect(2.0)
        }
    }

    var successView: some View {
        Group {
            Spacer()

            CircleView(
                icon: "checkmark",
                gradientOne: 0x70b068,
                gradientTwo: 0x457d3d,
                circleOneColor: 0xf0f2f0,
                circleTwoColor: 0xe3e7e2,
                circleThreeColor: 0xdee6dd
            )

            Text("Success!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 20)

            Text("Account created successfully, you should receive an email confirmation and your new account will appear in you accounts list within the next day.")
                .fontWeight(.bold)

            Spacer()

            if showAddMoreProducts {
                addMoreProductsButton
            }

            doneButton
        }
    }

    var failureView: some View {
        Group {
            Spacer()

            CircleView(
                icon: "exclamationmark.circle",
                gradientOne: 0xd06568,
                gradientTwo: 0xbb5b58,
                circleOneColor: 0xf3f1f1,
                circleTwoColor: 0xeee9e9,
                circleThreeColor: 0xe9e1e1
            )

            Text("Whoops!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 20)

            Text("Something went wrong! Please try again later.")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

//            Text(errorMessage)
//                .fontWeight(.bold)
//                .multilineTextAlignment(.center)

            Spacer()

            doneButton
        }
    }

    var addMoreProductsButton: some View {
        Button("Add more products", action: {
            onDoneTap()
        })
        .buttonStyle(ShrinkingButtonWhite())
        .padding(.bottom, 10)
    }

    var doneButton: some View {
        Button("Done", action: {
            onDoneTap()
        })
        .buttonStyle(ShrinkingButton())
    }
}

private struct CircleView: View {
    var icon: String
    var gradientOne: UInt
    var gradientTwo: UInt

    var circleOneColor: UInt
    var circleTwoColor: UInt
    var circleThreeColor: UInt

    var body: some View {
        ZStack {
            Spacer()
                .frame(width: 270, height: 270)
                .background(Color(hex: circleOneColor, alpha: 0.3))
                .clipShape(Circle())

            Spacer()
                .frame(width: 210, height: 210)
                .background(Color(hex: circleTwoColor, alpha: 0.3))
                .clipShape(Circle())

            Spacer()
                .frame(width: 150, height: 150)
                .background(Color(hex: circleThreeColor, alpha: 0.4))
                .clipShape(Circle())

            Image(systemName: icon)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Color.white)
                .padding(40)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(hex: gradientOne), Color(hex: gradientTwo)]), startPoint: .top, endPoint: .bottom)
                )
                .clipShape(Circle())
        }
    }
}

#Preview {
    ConfirmationView(
        state: .constant(.failure),
        errorMessage: .constant("Error message from the API"),
        showAddMoreProducts: true
    ) {}
}
