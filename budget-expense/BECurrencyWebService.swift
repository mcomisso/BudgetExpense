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

final class BECurrencyWebService {

    let currencyParser = BECurrencyParser()

    func fetchUpdatedRates() {
        Alamofire.request(baseURL).responseJSON { (response) in
            print(response.result)
            if let json = response.result.value {
                BERealmManager.shared.saveCurrencies(self.currencyParser.parse(json))
            } else {
                print("Wrong json serialization?")
            }
        }
    }
}

final class BECurrencyParser {

    func parse(_ json: Any) -> [BECurrency] {

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

}
