//
//  ConfigurationViewController.swift
//  miApp
//
//  Created by 2020-1 on 11/20/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class ConfigurationViewController: TemplateViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.asignDelegates()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
// MARK: Events
extension ConfigurationViewController {
  @IBAction func saveMyConfiguration(_ sender: UIButton){
    let sv = TemplateViewController.displaySpinner(onView: self.view)
    // TODO: Validation Validation with trim important
//    let name = self.nameTextField.text!
//    let username = self.usernameTextField.text!
//    let email = self.emailTextField.text!
//    let password = self.passwordTextField.text!
    // MARK: Request
    //    TODO: make network
    //
    TemplateViewController.removeSpinner(spinner: sv)
  }
  
  @IBAction func logOutAction(_ sender: UIButton){
    let sv = TemplateViewController.displaySpinner(onView: self.view)
    // TODO: Validation Validation with trim important
//    let name = self.nameTextField.text!
//    let username = self.usernameTextField.text!
//    let email = self.emailTextField.text!
//    let password = self.passwordTextField.text!
    // MARK: Request
    SessionHelper().removeSession()
    self.tabBarController?.dismiss(animated: true, completion: {
      print("Holi")
    })
    //
    TemplateViewController.removeSpinner(spinner: sv)
  }
  
}


// MARK: UITextFieldDelegate
extension ConfigurationViewController {
  
  func asignDelegates() {
    self.nameTextField.delegate = self
    self.usernameTextField.delegate = self
    self.emailTextField.delegate = self
    self.passwordTextField.delegate = self
  }
  
}
