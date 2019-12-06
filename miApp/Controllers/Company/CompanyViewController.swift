//
//  CompanyViewController.swift
//  miApp
//
//  Created by 2020-1 on 11/20/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class CompanyViewController: TemplateViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var initialIncomesTextField: UITextField!
  @IBOutlet weak var initialExpensesTextField: UITextField!
  @IBOutlet weak var saveButton: UIButton!


  override func viewDidLoad() {
    super.viewDidLoad()
    self.asignDelegates()
    self.loadCompany()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }

}

// MARK: Events
extension CompanyViewController {
  @IBAction func saveMyCompany(_ sender: UIButton){
    let sv = TemplateViewController.displaySpinner(onView: self.view)
    // TODO: Validation Validation with trim important
    let name = self.nameTextField.text!
    let initialIncomes = self.initialIncomesTextField.text!
    let initialExpenses = self.initialExpensesTextField.text!
    // MARK: Request
    CompanyService.create(name: name,
                          initial_incomes: initialIncomes.floatValue,
                          initial_expenses: initialExpenses.floatValue,
                          balance: 0.0,
                          UserId: SessionHelper().getUserId()!,
                          image: "") {
                            (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      switch httpResponse.statusCode {
      case 200:
        let decoder = JSONDecoder()
        do {
          let company = try decoder.decode(Company.self, from: data)
          print(company)
        } catch let err {
          print("Parsing Error: \(err)")
        }
      case 412:
        let alert = UIAlertController(title: "Unauthorized", message: "Session was expired. Try login again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      default:
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }

    }
    //
    TemplateViewController.removeSpinner(spinner: sv)
  }
  
  @IBAction func backToHome(_ sender: UIButton){
    self.navigationController?.popViewController(animated: true)
  }
  
  func loadCompany() {
    self.nameLabel.text = SessionHelper().getNameCompany()
    self.nameTextField.text = SessionHelper().getNameCompany()
    self.initialIncomesTextField.text = "\(SessionHelper().getInitialIncomesCompany() ?? 0)"
    self.initialExpensesTextField.text = "\(SessionHelper().getInitialExpensesCompany() ?? 0)"
  }
  
}


// MARK: UITextFieldDelegate
extension CompanyViewController {
  
  func asignDelegates() {
    self.nameTextField.delegate = self
    self.initialIncomesTextField.delegate = self
    self.initialExpensesTextField.delegate = self
  }
  
}


