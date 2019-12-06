//
//  AccessViewController.swift
//  miApp
//
//  Created by 2020-1 on 11/26/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class LoginViewController: TemplateViewController {
  //  MARK: Outlets
  @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var profileImage: UIImageView!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.asignDelegates()
    self.setUpProfileImage()
    self.keyboardHeightLayoutConstraintRoot = self.keyboardHeightLayoutConstraint
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if SessionHelper().isLoggedIn() != nil {
      let mainTab = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
      self.navigationController?.pushViewController(mainTab, animated: true)
    }
  }
  
}

// MARK: Events
extension LoginViewController {
  @IBAction func doLogin(_ sender: UIButton){
    let sv = TemplateViewController.displaySpinner(onView: self.view)
    let email = self.emailTextField.text!
    let password = self.passwordTextField.text!
    // MARK: Request
    self.handleLoginEvent(email: email, password: password)
    TemplateViewController.removeSpinner(spinner: sv)
  }
  
}

// MARK: -UITextFieldDelegate
extension LoginViewController {
  func asignDelegates() {
    self.emailTextField.delegate = self
    self.passwordTextField.delegate = self
  }
}

// MARK: STYLES - PROFILE IMAGE
extension LoginViewController {
  func setUpProfileImage() {
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
    self.profileImage.layer.masksToBounds = true
    self.profileImage.layer.borderWidth = 0
    self.profileImage.contentMode = .scaleToFill
    self.profileImage.clipsToBounds = true
  }
}
