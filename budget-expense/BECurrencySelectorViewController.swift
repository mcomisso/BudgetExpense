//
//  BECurrencySelectorViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 17/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

final class BECurrencySelectorViewController: UITableViewController {

    let currencies: [String] = BERealmManager.shared.listCurrencies()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension BECurrencySelectorViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.currencyCellReuseIdentifier, for: indexPath) {

            cell.textLabel?.text = self.currencies[indexPath.row]
            cell.detailTextLabel?.text = (NSLocale.system as NSLocale).displayName(forKey: .currencyCode, value: self.currencies[indexPath.row])
            return cell
        }
        fatalError()
    }
}

extension BECurrencySelectorViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: false) }

        if let cell = tableView.cellForRow(at: indexPath),
            let text = cell.textLabel?.text {
            let alert = UIAlertController.init(title: "Set the base currency as \(text)?", message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { [weak self] (alertaction) in
                // Signal selection successful
                BERealmManager.shared.setCurrency(forActiveCurrency: false, currencyCode: text)
                self?.dismiss(animated: true, completion: nil)
            }))

            alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }

    }
}
