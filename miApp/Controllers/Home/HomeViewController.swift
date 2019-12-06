//
//  HomeViewController.swift
//  miApp
//
//  Created by 2020-1 on 11/20/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class HomeViewController: TemplateViewController {
  
  @IBOutlet weak var fromTextField: UITextField!
  @IBOutlet weak var toTextField: UITextField!
  @IBOutlet weak var incomesLabel: UILabel!
  @IBOutlet weak var expensesLabel: UILabel!
  @IBOutlet weak var balanceLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.asignDelegates()
    self.getCurrentUserAndStore()
    self.loadDefaults()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
    self.getCompany()
    print("Holi")
    // MARK: Navigate to home
  }
  
  func loadDefaults() {
    let date = Calendar.current.dateComponents(MyDate.requestedComponents, from: Date())
    let stringDate = "\(date.day ?? 20)/\(date.month ?? 04)/\(date.year ?? 1994)"
    self.fromTextField.text = stringDate
    self.toTextField.text = stringDate
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

// MARK: ACTIONS OR EVENTS
extension HomeViewController {
  
  func getCurrentUserAndStore() {
    UserService.currentUser { (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      switch httpResponse.statusCode {
        case 200:
          let decoder = JSONDecoder()
          do {
            let json = try decoder.decode(User.self, from: data)
            let s = SessionHelper()
            s.setUserId(value: json.id!)
            s.setUserUsername(value: json.username)
            s.setUserEmail(value: json.email)
            DispatchQueue.main.sync {
              self.usernameLabel.text = json.username
            }
          } catch let err {
            print("Parsing Error: \(err)")
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
  
  func getCompany() {
    CompanyService.getMyCompany { (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      switch httpResponse.statusCode {
      case 200:
        let decoder = JSONDecoder()
        do {
          let json = try decoder.decode([Company].self, from: data)
          if (json.count == 0) {
            let alert = UIAlertController(title: "Upps", message: "Your Company was not found, please add one", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: "create company"), style: .default, handler: {(alert: UIAlertAction!) in
              let companyController = self.storyboard?.instantiateViewController(withIdentifier: "companyView") as! TemplateViewController
              self.navigationController?.pushViewController(companyController, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
          } else {
            let company = json[0]
            SessionHelper().setIdCompany(value: company.id!)
            SessionHelper().setNameCompany(value: company.name)
            SessionHelper().setInitialIncomesCompany(value: company.initial_incomes)
            SessionHelper().setInitialExpensesCompany(value: company.initial_expenses)
            SessionHelper().setImageCompany(value: company.image!)
            SessionHelper().setBalanceCompany(value: company.balance)
            SessionHelper().setCreatedAtCompany(value: company.createdAt ?? "")
            SessionHelper().setUpdatedAtCompany(value: company.updatedAt ?? "")
            DispatchQueue.main.sync {
              self.incomesLabel.text = "$\(SessionHelper().getInitialIncomesCompany() ?? 0)"
              self.expensesLabel.text = "$\(SessionHelper().getInitialExpensesCompany() ?? 0)"
              self.balanceLabel.text = "$\(SessionHelper().getBalanceCompany() ?? 0)"
            }
          }
        } catch let err {
          print("Parsing Error: \(err)")
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
}

extension HomeViewController {
  func asignDelegates() {
    self.fromTextField.delegate = self
    self.toTextField.delegate = self
  }
}
