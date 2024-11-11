//
//  CustomContactsUseCase.swift
//  Copyright © 2022 Westerra CU. All rights reserved.
//

import Foundation
import RetailPaymentJourney

class CustomContactsUseCase: ContactsUseCase {

    func retrieveContactsPage(parameters: ContactsPageRequestParameters, completion: @escaping RetrieveContactsCompletion) {

        guard var urlComponents = ServerEndpoint.contactList.urlComponents else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "from", value: "0")
        ]

        guard let url = urlComponents.url else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil
            else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }

            do {
                let contactsList = try JSONDecoder()
                    .decode([CodableContact].self, from: data)
                    .map { return Contact(from: $0) }

                completion(.success(ContactsPage(contacts: contactsList, nextPageCursor: nil)))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(.failed(error: error)))
            }
        }
        .resume()
    }

    // Does not need to be handled as we're using the ContactsJourney ContactAddForm to accomplish this functionality
    func saveContact(name: String, email: String?, phoneNumber: String?, completion: @escaping SaveContactCompletion) { }
}
