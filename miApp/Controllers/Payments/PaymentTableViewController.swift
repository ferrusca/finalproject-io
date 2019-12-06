//
//  PaymentTableViewController.swift
//  miApp
//
//

import UIKit

class PaymentTableViewController: UITableViewController {
  var payments = [Payment]()
  let cellIdentifier = "paymentCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    self.loadMyPayments()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.payments.count
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (payments[indexPath.row].state == true) {
      cell.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PaymentTableViewCell
    let payment = payments[indexPath.row]
    cell.namePayment.text = payment.name
    cell.productPayment.text = payment.product_name
    cell.datePayment.text = "\(payment.date_of_pay ?? "N/A")"
    cell.amountPayment.text = "$\(payment.product_amount)"
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
      PaymentService.delete(id: self.payments[indexPath.row].id!) { (data, response, error) in
        guard error == nil else { return }
        guard let httpResponse = response as? HTTPURLResponse else { return }
        guard let _ = data else { return }
        let paymentDelete = self.payments[indexPath.row]
        switch httpResponse.statusCode {
        case 204:
          self.payments.remove(at: indexPath.row)
          let session = SessionHelper()
          CompanyService.update(
            id: session.getIdCompany()!,
            name: session.getNameCompany()!,
            initial_incomes: session.getInitialIncomesCompany()!,
            initial_expenses: session.getInitialExpensesCompany()!,
            balance: session.getBalanceCompany()! - paymentDelete.product_amount,
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
          let alert = UIAlertController(title: "Unauthorized", message: "Please check your credentials", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        default:
          let alert = UIAlertController(title: "Opps", message: "Something was wrong sorry", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
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

  
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "paymentDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let object = self.payments[indexPath.row]
        let controller = segue.destination as! PaymentDetailViewController
        controller.myPayment = object
      }
    }
  }

}

// MARK: REQUEST
extension PaymentTableViewController {
  func loadMyPayments() {
    PaymentService.getMyPayments { (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      switch httpResponse.statusCode {
      case 200:
        let decoder = JSONDecoder()
        do {
          let myPayments = try decoder.decode([Payment].self, from: data)
          self.payments = myPayments
          DispatchQueue.main.sync {
            self.tableView.reloadData()
          }
        } catch {
          print("Error in parse PaymentTableViewController")
        }
      case 401:
        let alert = UIAlertController(title: "Unauthorized", message: "Please check your credentials", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      default:
        let alert = UIAlertController(title: "Opps", message: "Something was wrong sorry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
}
