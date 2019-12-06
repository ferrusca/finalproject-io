
import UIKit

class RegisterViewController: TemplateViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
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
extension RegisterViewController {
  
  @IBAction func routeToLoginView(_ sender: UIButton!) {
    _ = navigationController?.popViewController(animated: true)
  }
  
  @IBAction func doRegister(_ sender: UIButton) {
    // TODO: Validation with trim important
    let name = self.nameTextField.text!
    let username = self.userNameTextField.text!
    let email = self.emailTextField.text!
    let password = self.passwordTextField.text!
    // MARK: Request
    UserService.create(name: name, username: username, email: email, password: password){ (data, response, error) in
      guard error == nil else { return }
      guard let httpResponse = response as? HTTPURLResponse else { return }
      switch httpResponse.statusCode {
      case 200:
        self.handleLoginEvent(email: email, password: password)
      case 412:
        let alert = UIAlertController(title: "Precondition Failed", message: "Please check all attributes", preferredStyle: .alert)
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

// MARK: UITextFieldDelegate
extension RegisterViewController {
  
  func asignDelegates() {
    self.nameTextField.delegate = self
    self.emailTextField.delegate = self
    self.userNameTextField.delegate = self
    self.passwordTextField.delegate = self
  }
  
}

