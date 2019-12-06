import UIKit

class CreditTableViewController: UITableViewController {
  var debits = [Debit]()
  let cellIdentifier = "debitCell"
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadMyDebits()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.debits.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CreditTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CreditTableViewCell
    let credit = debits[indexPath.row]
    cell.nameCredit.text = credit.name
    cell.productCredit.text = credit.product_name
    cell.dateCredit.text = "\(credit.date_of_pay ?? "N/A")"
    cell.amountCredit.text = "$\(credit.product_amount)"
    return cell
  }
  

  /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  */

  
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
      DebitService.delete(id: self.debits[indexPath.row].id!) { (data, response, error) in
        guard error == nil else { return }
        guard let httpResponse = response as? HTTPURLResponse else { return }
        guard let _ = data else { return }
        let creditDelete = self.debits[indexPath.row]
        switch httpResponse.statusCode {
        case 204:
          self.debits.remove(at: indexPath.row)
          let session = SessionHelper()
          CompanyService.update(
            id: session.getIdCompany()!,
            name: session.getNameCompany()!,
            initial_incomes: session.getInitialIncomesCompany()!,
            initial_expenses: session.getInitialExpensesCompany()!,
            balance: session.getBalanceCompany()! + creditDelete.product_amount,
            UserId: session.getUserId()!, image: "") { (data, response, error) in
              guard error == nil else { return }
              guard let httpResponse = response as? HTTPURLResponse else { return }
              guard data != nil else { return }
              if httpResponse.statusCode == 200 {
                print("OK")
              }
          }

          DispatchQueue.main.async {
            tableView.deleteRows(at: [indexPath], with: .fade)
          }
        case 401:
          let alert = UIAlertController(title: "Unauthorized", message: "Unauthorized", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        default:
          let alert = UIAlertController(title: "Error", message: "Something went wrong. Try again later", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
      }
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  

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

}

// MARK: REQUEST
extension CreditTableViewController {
  func loadMyDebits() {
    DebitService.getMyDebits { (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      switch httpResponse.statusCode {
      case 200:
        let decoder = JSONDecoder()
        do {
          let myCredits = try decoder.decode([Debit].self, from: data)
          self.debits = myCredits
          DispatchQueue.main.sync {
            self.tableView.reloadData()
          }
        } catch {
          print("Error in parse PaymentTableViewController")
        }
      case 401:
        let alert = UIAlertController(title: "Unauthorized", message: "Su sesión ha expirado. Verifique", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      default:
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
}

