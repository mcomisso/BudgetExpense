//
//  BERestCountriesWebService.swift
//  budget-expense
//
//  Created by Matteo Comisso on 21/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire

final class BERestCountriesWebService {
    let parser = BEParser()

    func askForCurrencyFromCountryCode(_ code: String, completion: ((Bool, String?)->Void)? = nil) {
        let manager = Alamofire.SessionManager.default

        manager.session.configuration.timeoutIntervalForRequest = 5

        var urlComponents = URLComponents(url: restCountriesURL, resolvingAgainstBaseURL: false)!
        let countryCode = URLQueryItem(name: "codes", value: code)
        let filterFields = URLQueryItem(name: "fields", value: "name;currencies")

        urlComponents.queryItems = [countryCode, filterFields]

        manager.request(urlComponents.url!).responseJSON { (response) in


            // Check value, otherwise abort
            guard let value = response.result.value else {

                if let completion = completion {
                    completion(false, nil)
                }
                return
            }

            let parsedCountry = self.parser.parseCountry(value)

            if let completion = completion {
                completion(true, parsedCountry?.currency)
            }
        }
    }
}
