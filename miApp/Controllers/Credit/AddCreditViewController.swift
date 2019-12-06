//
//  AddCreditViewController.swift
//  

import UIKit
import DatePickerDialog

class AddCreditViewController: TemplateViewController {
  @IBOutlet weak var nameClientDebit: UITextField!
  @IBOutlet weak var nameProductDebit: UITextField!
  @IBOutlet weak var costProductDebit: UITextField!
  @IBOutlet weak var dateOfPayProductDebit: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.asignDelegates()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}

//MARK: EVENTS
extension AddCreditViewController {
  @IBAction func createDebit(_ sender: UIButton) {
    let name = self.nameClientDebit.text!
    let product_name = self.nameProductDebit.text!
    let product_amount = self.costProductDebit.text!
    let date_of_pay = self.dateOfPayProductDebit.text!
    DebitService.create(
      name: name,
      product_name: product_name,
      product_amount: product_amount.floatValue,
      date_of_pay: date_of_pay,
      paid: false) { (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard data != nil else { return }
      switch httpResponse.statusCode {
        case 200:
          let session = SessionHelper()
          CompanyService.update(
            id: session.getIdCompany()!,
            name: session.getNameCompany()!,
            initial_incomes: session.getInitialIncomesCompany()!,
            initial_expenses: session.getInitialExpensesCompany()!,
            balance: session.getBalanceCompany()! - product_amount.floatValue,
            UserId: session.getUserId()!, image: "") { (data, response, error) in
              guard error == nil else { return }
              guard let httpResponse = response as? HTTPURLResponse else { return }
              guard data != nil else { return }
              if httpResponse.statusCode == 200 {
                self.dismiss(animated: true, completion: nil)
              }
          }
        default:
          let alert = UIAlertController(title: "Error", message: "Something went wrong. Try again later", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
      
    }
  }

  @IBAction func presentDateOfPay(sender: UIButton) {
    DatePickerDialog().show("Día de pago  ", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
      (date) -> Void in
      if let dt = date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        self.dateOfPayProductDebit.text = formatter.string(from: dt)
      }
    }
  }
}

//MARK: Asign Delegates
extension AddCreditViewController {
  func asignDelegates() {
    self.nameClientDebit.delegate = self
    self.nameProductDebit.delegate = self
    self.costProductDebit.delegate = self
  }
}

