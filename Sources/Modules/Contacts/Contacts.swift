//
//  Contacts.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import BackbaseDesignSystem
import Foundation
import RetailAppCommon
import RetailContactsJourney
import RetailJourneyCommon
import RetailUSApp
import UIKit

extension Contacts {

    /// This is the configuration of the Contacts module
    static func configure() -> Contacts.Configuration {

        var contacts = Contacts.Configuration()

        // Adjust configuration settings
        contacts.form.strings.nameLabel = LocalizedString("contact.form.name.label")
        contacts.form.strings.namePlaceholder = LocalizedString("contact.form.name.placeholder")
        contacts.details.strings.nameTitle = LocalizedString("contact.detail.name.label")

        contacts.router.onTapEditContact = { navigationController in
            return { contact in
                let editContactVC = ContactForm.buildEdit(contact: contact)(navigationController)

                if let textInput = (UIView.getAllSubviews(from: editContactVC.view)).last(where: { $0 is BackbaseDesignSystem.TextInput }) {
                    textInput.isUserInteractionEnabled = false
                }

                let editContactNavigationController = UINavigationController(rootViewController: editContactVC)
                editContactNavigationController.navigationBar.prefersLargeTitles = true
                editContactNavigationController.navigationBar.tintColor = UIColor(light: .dark, dark: .white)
                navigationController.present(editContactNavigationController, animated: true)
            }
        }

        return contacts
    }
}
