//
//  PaymentDetailViewController.swift
//  miApp
//
//  Created by 2020-1 on 11/20/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class PaymentDetailViewController: TemplateViewController {
  
  var myPayment: Payment = Payment(name: "", product_name: "", product_amount: 0.0, date_of_pay: "", state: false)
  @IBOutlet weak var myView: UIView!
  @IBOutlet weak var nameClientLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productAmountLabel: UILabel!
  @IBOutlet weak var dateOfPayLabel: UILabel!
  @IBOutlet weak var chargeButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadDefault()
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

extension PaymentDetailViewController {
  func loadDefault() {
    self.nameClientLabel.text = self.myPayment.name
    self.productNameLabel.text = self.myPayment.product_name
    self.productAmountLabel.text = "$\(self.myPayment.product_amount)"
    self.dateOfPayLabel.text = self.myPayment.date_of_pay
    DispatchQueue.main.async {
      self.myView.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
    }
  }
}

// MARK: - Events
extension PaymentDetailViewController {
  @IBAction func doCharge(sender: UIButton) {
    PaymentService.update(id: self.myPayment.id!, name: self.myPayment.name, product_name: self.myPayment.product_name, product_amount: self.myPayment.product_amount, date_of_pay: self.myPayment.date_of_pay ?? "", state: true) { (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard data != nil else { return }
      print(httpResponse.statusCode)
      switch httpResponse.statusCode {
        case 204:
          DispatchQueue.main.async {
           self.myView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
          }
          let alert = UIAlertController(title: "Updated", message: "This payment have been payed :)", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
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
