//
//  BECurrencyWebService.swift
//  budget-expense
//
//  Created by Matteo Comisso on 16/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

fileprivate let baseURL = URL(string: "https://api.fixer.io/latest")!
fileprivate let restCountriesURL = URL(string: "https://restcountries.eu/rest/v2/alpha")!

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

final class BEParser {

    func parseCurrencies(_ json: Any) -> [BECurrency] {

        let parsedJSON = JSON(json)

        var retVal = [BECurrency]()

        let baseCurrency = BECurrency.init(currency: parsedJSON["base"].stringValue, value: 1.0, isBase: true)

        let rates = parsedJSON["rates"].dictionaryValue
        for key in rates.keys {
            let currency = BECurrency(currency: key, value: (rates[key]?.doubleValue)!)
            retVal.append(currency)
        }

        retVal.append(baseCurrency)
        return retVal
    }

    func parseCountry(_ json: Any) -> BECurrency? {
        let parsedJSON = JSON(json)

        // [{"currencies":[{"code":"EUR","name":"Euro","symbol":"€"}],"name":"Italy"}]

        guard let result = parsedJSON.arrayValue.first?.dictionaryValue else { return nil }

        guard let foundCurrencies = result["currencies"]?.arrayValue else { return nil }

        guard let currencyCode = foundCurrencies.first?.dictionaryValue["code"] else { return nil }

        return BERealmManager.shared.getCurrencyFromCode(currencyCode.stringValue)
    }

}
