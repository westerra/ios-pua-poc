//
//  FinePrintView.swift
//  Copyright © 2024 Westerra CU. All rights reserved.
//

import SwiftUI

struct FinePrintView: View {
    @ObservedObject var viewModel: BehindThePinViewModel

    private let accountAgreementUrl = URL(string: "https://www.westerracu.com/docs/Account_Agreement.pdf")
    private let savingsRateUrl = URL(string: "https://www.westerracu.com/resources/rates?q=personal-savings-and-checking-rates")
    private let feeScheduleUrl = URL(string: "https://www.westerracu.com/feeschedule")
    private let electronicDisclosureUrl = URL(string: "https://www.westerracu.com/resources/disclosures?q=electronic-disclosure-and-consent")
    private let wegotyaDisclosuresUrl = URL(string: "https://www.westerracu.com/wegotyadisclosure")

    var body: some View {
        BaseView(mainContent: {
            mainContent
        }, bottomContent: {
            bottomContent
        })
        .navigationTitle("The Fine Print")
    }

    var mainContent: some View {
        VStack(alignment: .leading) {
            LinkText(text: "Westerra Account Agreement", link: accountAgreementUrl)
            LinkText(text: "Savings Rates", link: savingsRateUrl)
            LinkText(text: "Fee Schedule", link: feeScheduleUrl)
            LinkText(text: "Electronic Disclosure and Consent", link: electronicDisclosureUrl)

            CheckBox(text: "By creating an account, you agree with Westerra’s terms & conditions", checked: $viewModel.termsChecked)
            CheckBox(text: "I certify that I’m not subject to IRS backup withholdings.", checked: $viewModel.certifyChecked)

            Text(
                "We understand that life happens! If you want Westerra to authorize and pay overdrafs on one-time and recurring debit card transactions, " +
                "make you election below. If you prefer for us no to pay, Opting Out will occur when the box is not selected."
            )
            .padding(.bottom, 8)

            LinkText(text: "WeGotYa Courtesy Pay Disclosure", link: wegotyaDisclosuresUrl)

            CheckBox(
                text: "I want Westerra Credit Union to authorize and pay overdrafts on my one-time and " + "recurring debig card transactions, through WeGotYa/Courtesy Pay.",
                checked: $viewModel.authorizeChecked
            )

            Text("Updates to disclosure will be on our website.")

            Spacer()
        }
    }

    var bottomContent: some View {
        ContinueButton(
            enabled: $viewModel.agreementsChecked,
            onTap: {
                Task {
                    await viewModel.onScreen(event: .onFinePrint)
                }
            }
        )
    }
}

struct LinkText: View {
    var text: String
    var link: URL?

    @State private var showSafari = false

    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.aquaDark)
            .italic()
            .underline()
            .padding(.bottom, 8)
            .onTapGesture {
                showSafari = true
            }
            .sheet(isPresented: $showSafari) {
                if let url = link {
                    SafariView(url: url)
                }
            }
    }
}

struct CheckBox: View {
    var text: String
    @Binding var checked: Bool

    var body: some View {
        HStack {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? Color.appTheme : Color.secondary)
                .padding(.trailing, 8)

            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .italic()
        }
        .padding(.bottom, 10)
        .onTapGesture {
            checked.toggle()
        }
    }
}

#Preview {
    FinePrintView(
        viewModel: .init(
            coordinator: MockBehindThePinCoordinator(),
            accountService: MockAccountService()
        )
    )
}
