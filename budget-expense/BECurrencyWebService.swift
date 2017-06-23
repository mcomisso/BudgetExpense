//
//  BECurrencyWebService.swift
//  budget-expense
//
//  Created by Matteo Comisso on 16/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let baseURL = URL(string: "https://api.fixer.io/latest")!

final class BECurrencyWebService {

    let currencyParser = BEParser()

    func fetchUpdatedRates(completion: ((Bool)->Void)? = nil) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 5

        manager.request(baseURL).responseJSON { (response) in
            print(response.result)
            if let json = response.result.value {
                BERealmManager.shared.saveCurrencies(self.currencyParser.parseCurrencies(json))
                if let completion = completion {
                    completion(true)
                }
            } else {
                print("Wrong json serialization?")
                if let completion = completion {
                    completion(false)
                }
            }
        }
    }
}
