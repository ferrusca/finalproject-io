//
//  PaymentService.swift
//

import Foundation

class PaymentService: Network {
  static let paymentService: PaymentService = PaymentService()
  
  //  MARK: GET MY PAYMENT
  class func getMyPayments(_ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    paymentService.components.path = "/payments"
    
    var req = URLRequest(url: paymentService.components.url!)
    req.httpMethod = "GET"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
    
  }
  
  //  MARK: CREATE PAYMENT
  class func create(
    name: String,
    product_name: String,
    product_amount: Float,
    date_of_pay: String,
    state: Bool,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    paymentService.components.path = "/payments"
    
    var req = URLRequest(url: paymentService.components.url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let payment = Payment(name: name,
                          product_name: product_name,
                          product_amount: product_amount,
                          date_of_pay: date_of_pay,
                          state: state)
    let data = try! JSONEncoder().encode(payment)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }

  //  MARK: UPDATE PAYMENT
  class func update(
    id: Int,
    name: String,
    product_name: String,
    product_amount: Float,
    date_of_pay: String,
    state: Bool,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    paymentService.components.path = "/payments/\(id)"
    
    var req = URLRequest(url: paymentService.components.url!)
    req.httpMethod = "PUT"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let payment = Payment(id: id,
                          name: name,
                          product_name: product_name,
                          product_amount: product_amount,
                          date_of_pay: date_of_pay,
                          state: state
                          )
    let data = try! JSONEncoder().encode(payment)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }

  //  MARK: DELETE PAYMENT
  class func delete(
    id: Int,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    paymentService.components.path = "/payments/\(id)"
    
    var req = URLRequest(url: paymentService.components.url!)
    req.httpMethod = "DELETE"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }
  
}
