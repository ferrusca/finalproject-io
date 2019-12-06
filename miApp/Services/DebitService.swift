
import Foundation
class DebitService: Network {
  static let debitService: DebitService = DebitService()
  
  //  MARK: GET MY DEBITS
  class func getMyDebits(_ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    debitService.components.path = "/debits"
    
    var req = URLRequest(url: debitService.components.url!)
    req.httpMethod = "GET"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
    
  }
  
  //  MARK: CREATE DEBIT
  class func create(
    name: String,
    product_name: String,
    product_amount: Float,
    date_of_pay: String,
    paid: Bool,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    debitService.components.path = "/debits"
    
    var req = URLRequest(url: debitService.components.url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let debit = Debit(name: name,
                      product_name: product_name,
                      product_amount: product_amount,
                      date_of_pay: date_of_pay,
                      state: state)
    let data = try! JSONEncoder().encode(debit)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }

  //  MARK: UPDATE DEBIT
  class func update(
    id: Int,
    name: String,
    product_name: String,
    product_amount: Float,
    date_of_pay: String, 
    state: Bool,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    debitService.components.path = "/debits/\(id)"
    
    var req = URLRequest(url: debitService.components.url!)
    req.httpMethod = "PUT"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let debit = Debit(name: name,
                      product_name: product_name,
                      product_amount: product_amount,
                      date_of_pay: date_of_pay,
                      state: state)
    let data = try! JSONEncoder().encode(debit)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }

  //  MARK: CREATE PAYMENT
  class func delete(
    id: Int,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    debitService.components.path = "/debits/\(id)"
    
    var req = URLRequest(url: debitService.components.url!)
    req.httpMethod = "DELETE"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }
  
}
