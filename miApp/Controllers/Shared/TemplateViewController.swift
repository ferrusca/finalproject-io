//
//  AccessViewController.swift
//  miApp
//
//  Created by 2020-1 on 11/25/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class TemplateViewController: UIViewController {
  //This constraint sticks at zero points from the bottom layout guide
  var keyboardHeightLayoutConstraintRoot: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUpKeyboardDismissRecognizer()
    self.handleKeyBoardReveal()
    // Do any additional setup after loading the view.
  }
  
}

//MARK: EVENTS
extension TemplateViewController {
  func handleLoginEvent(email: String, password: String) {
    UserService.auth(email: email, password: password) { (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      switch httpResponse.statusCode {
        case 200:
          UserService.storeToken(data, completion: { (Auth) in
            SessionHelper().setLoggedIn(value: Auth.token)
            // MARK: Navigate to home
            let mainTab = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
            self.navigationController?.pushViewController(mainTab, animated: true)
          })
        case 401:
          let alert = UIAlertController(title: "Unauthorized", message: "Please check your credentials", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        default:
          let alert = UIAlertController(title: "Error", message: "Something went wrong. Try again later", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
    }
  }

}

// MARK Keyboard
extension TemplateViewController {
  func handleKeyBoardReveal() {
    NotificationCenter
      .default
      .addObserver(
        self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: NSNotification.Name.UIKeyboardWillChangeFrame,
        object: nil
    )
  }
  
  @objc func keyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      let endFrameY = endFrame?.origin.y ?? 0
      let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
      let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
      if endFrameY >= UIScreen.main.bounds.size.height {
        self.keyboardHeightLayoutConstraintRoot?.constant = 0.0
      } else {
        self.keyboardHeightLayoutConstraintRoot?.constant = CGFloat(-0.3) * (endFrame?.size.height ?? 0.0)
      }
      UIView.animate(withDuration: duration,
                     delay: TimeInterval(0),
                     options: animationCurve,
                     animations: { self.view.layoutIfNeeded() },
                     completion: nil)
      print("Keyboard pressed!!!")
    }
  }
  
  
  //  dismiss keyboard
  func setUpKeyboardDismissRecognizer() {
    let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TemplateViewController.dismissKeyboard))
    self.view.addGestureRecognizer(tapRecognizer)
  }
  
  @objc func dismissKeyboard() {
    self.view.endEditing(true)
  }
  //===========================
  
}

// MARK: UITextFieldDelegate
extension TemplateViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
}

// MARK: loader
extension TemplateViewController {
  class func displaySpinner(onView : UIView) -> UIView {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }
    
    return spinnerView
  }
  
  class func removeSpinner(spinner :UIView) {
    DispatchQueue.main.async {
      spinner.removeFromSuperview()
    }
  }
}

