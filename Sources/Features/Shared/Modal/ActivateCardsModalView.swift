//
//  ModalView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

class ModalViewConfiguration {
    weak var hostingController: UIViewController?
}

struct ActivateCardsModalView: View {
    let config: ModalViewConfiguration
    let phoneNumber = "1-866-762-0558"

    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing ) {
                VStack(alignment: .center, spacing: 20) {
                    westerraLogo
                    bodyText
                    continueButton
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 20)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3.0)

                Button(action: {
                    closeModalView()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.textPrimary)
                        .offset(x: 10, y: -10)
                        .background(Color.appBackground)
                })
            }
            .padding(20)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(
                BackgroundBlurView()
                    .opacity(0.7)
            )
        }
    }

    var westerraLogo: some View {
        Image(.westerraLogo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
    }

    var bodyText: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reminder: Activate Your Card(s) Now")
                .font(.system(size: 30, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)

            Text("We want to ensure members' use of their Westerra debit and credit cards are not disrupted!")

            Group {
                Text("If you have recently received a new debit or credit card and have NOT activated it, please do so as soon as possible. To activate your card, call ")
                +
                Text(phoneNumber)
                    .foregroundColor(.aquaDark)
            }
            .multilineTextAlignment(.leading)
            .onTapGesture {
                if let phoneNumberUrl = URL(string: "tel://\(phoneNumber)") {
                    UIApplication.shared.open(phoneNumberUrl)
                }
            }
        }
    }

    var continueButton: some View {
        VStack(alignment: .center) {
            Button(action: {
                closeModalView()
            }, label: {
                Text("Continue")
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(Color.appTheme)
                    .foregroundColor(.textPrimaryReversed)
                    .clipShape(Capsule())
            })
            .frame(width: 220)
        }
    }

    func closeModalView() {
        self.config.hostingController?.dismiss(animated: true)
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    ActivateCardsModalView(config: ModalViewConfiguration())
}
