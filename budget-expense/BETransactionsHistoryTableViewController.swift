//
//  BESettingsTableViewController.swift
//  budget-expense
//
//  Created by Matteo Comisso on 16/10/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import UIKit
import RealmSwift
import Material

class BEHeaderView: UITableViewHeaderFooterView {

    // Add a date
}

class BETableViewCell: UITableViewCell {

    @IBOutlet weak var card: Card!

    func prepareCardWithAmounObject(amount: Amount) {
        let amountLabel = UILabel()
        amountLabel.font = UIFont.systemFont(ofSize: 40)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.numberOfLines = 1
        amountLabel.textAlignment = .center
        amountLabel.text = BEUtils.formatNumberToCurrency(number: NSNumber(value: amount.amount))
        amountLabel.textColor = amount.isExpense ? BETheme.Colors.accent : BETheme.Colors.primary

        let verticalIconButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.blueGrey.base)


        let toolbar = Toolbar(rightViews: [verticalIconButton])
        toolbar.detail = amount.isExpense ? "Expense" : "Income"
        toolbar.detailLabel.textAlignment = .left
        toolbar.title = amount.category?.name
        toolbar.titleLabel.textAlignment = .left

        let dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.text = BEUtils().dateFormatter.string(from: amount.date)

        let bottomBar = Bar(leftViews: [dateLabel])

        card.toolbar = toolbar
        card.contentView = amountLabel
        card.bottomBar = bottomBar
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}


class BETransactionsHistoryTableViewController: UITableViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.closeButton.title = ""
        self.closeButton.image = Icon.close
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeView(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}
    // MARK: - Table view data source
extension BETransactionsHistoryTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BERealmManager.shared.getWeekDataForTableView().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BEConstants.Identifiers.overviewCellIdentifier, for: indexPath) as! BETableViewCell

        let amountObject = BERealmManager.shared.getWeekDataForTableView()[indexPath.row]

        cell.prepareCardWithAmounObject(amount: amountObject)

        return cell
    }
}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */