//
//  CompanyService.swift
//  miApp
//
//  Created by 2020-1 on 11/27/19.
//  Copyright © 2019 ios. All rights reserved.
//

import Foundation

class CompanyService: Network {
  static let companyService: CompanyService = CompanyService()
  
  //  MARK: GET MY COMPANY
  class func getMyCompany(_ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    companyService.components.path = "/companys"
    
    var req = URLRequest(url: companyService.components.url!)
    req.httpMethod = "GET"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
    
  }
  
  //  MARK: CREATE COMPANY
  class func create(
    name: String,
    initial_incomes: Float,
    initial_expenses: Float,
    balance: Float,
    UserId: Int,
    image: String,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    companyService.components.path = "/companys"
    
    var req = URLRequest(url: companyService.components.url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let company = Company(name: name,
                      initial_incomes: initial_incomes,
                      initial_expenses: initial_expenses,
                      balance: balance,
                      UserId: UserId,
                      image: image)
    let data = try! JSONEncoder().encode(company)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }
  
  //  MARK: CREATE COMPANY
  class func update(id: Int,
    name: String,
    initial_incomes: Float,
    initial_expenses: Float,
    balance: Float,
    UserId: Int,
    image: String,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    companyService.components.path = "/companys\(id)"
    
    var req = URLRequest(url: companyService.components.url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let company = Company(name: name,
                          initial_incomes: initial_incomes,
                          initial_expenses: initial_expenses,
                          balance: balance,
                          UserId: UserId,
                          image: image)
    let data = try! JSONEncoder().encode(company)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }
  
}
