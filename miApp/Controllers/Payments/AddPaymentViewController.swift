//
//  AddPaymentViewController.swift
//  miApp
//
//  Created by 2020-1 on 11/20/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit
import DatePickerDialog

class AddPaymentViewController: TemplateViewController {
  
  @IBOutlet weak var nameClientPayment: UITextField!
  @IBOutlet weak var nameProductPayment: UITextField!
  @IBOutlet weak var costProductPayment: UITextField!
  @IBOutlet weak var dateOfPayProductPayment: UILabel!
  var dateOfPay: String! = ""
  
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
extension AddPaymentViewController {
  @IBAction func createPayment(_ sender: UIButton) {
    let name = self.nameClientPayment.text!
    let product_name = self.nameProductPayment.text!
    let product_amount = self.costProductPayment.text!
    let date_of_pay = self.dateOfPay!
    PaymentService.create(
      name: name,
      product_name: product_name,
      product_amount: product_amount.floatValue,
      date_of_pay: date_of_pay,
      state: false) { (data, response, error) in
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
        balance: session.getBalanceCompany()! + product_amount.floatValue,
        UserId: session.getUserId()!, image: "") { (data, response, error) in
            guard error == nil else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard data != nil else { return }
            if httpResponse.statusCode == 204 {
              self.dismiss(animated: true, completion: nil)
            }
        }
      case 412:
        let alert = UIAlertController(title: "Upps", message: "Your session was ended", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Login", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      default:
        let alert = UIAlertController(title: "Opps", message: "Something was wrong sorry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
      
    }
  }
  
  @IBAction func presentDateOfPay(sender: UIButton) {
    DatePickerDialog().show("Date of pay", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
      (date) -> Void in
      if let dt = date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        self.dateOfPayProductPayment.text = formatter.string(from: dt)
        self.dateOfPay = formatter.string(from: dt)
        print(self.dateOfPayProductPayment.text!)
      }
    }
  }
}

//MARK: Asign Delegates
extension AddPaymentViewController {
  func asignDelegates() {
    self.nameClientPayment.delegate = self
    self.nameProductPayment.delegate = self
    self.costProductPayment.delegate = self
  }
}
