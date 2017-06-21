//
//  BEParser.swift
//  budget-expense
//
//  Created by Matteo Comisso on 21/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwifyJSON

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
