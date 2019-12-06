//
//  SessionHelper.swift
//  miApp
//
//  Created by 2020-1 on 11/25/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit
struct SessionHelper {
  let token = "token"
  let userId = "User_userId"
  let username = "User_username"
  let email = "User_email"
  
  let idCompany = "CompanyId"
  let nameCompany = "CompanyName"
  let initialIncomesCompany = "CompanyInitialIncomes"
  let initialExpensesCompany = "CompanyInitialExpenses"
  let imageCompany = "CompanyImage"
  let balanceCompany = "CompanyBalance"
  let createdAtCompany = "CompanyCreatedAt"
  let updatedAtCompany = "CompanyUpdatedAt"
  
  func setLoggedIn(value: String) {
    UserDefaults.standard.set(value, forKey: token)
  }
  func isLoggedIn() -> String? {
    return UserDefaults.standard.string(forKey: token)
  }
  
  func setUserId(value: Int) {
    UserDefaults.standard.set(value, forKey: userId)
  }
  
  func getUserId() -> Int? {
    return UserDefaults.standard.integer(forKey: userId)
  }
  
  func setUserUsername(value: String) {
    UserDefaults.standard.set(value, forKey: username)
  }
  
  func getUserUsername() -> String? {
    return UserDefaults.standard.string(forKey: username)
  }
  
  func setUserEmail(value: String) {
    UserDefaults.standard.set(value, forKey: email)
  }
  
  func getUserEmail() -> String? {
    return UserDefaults.standard.string(forKey: email)
  }

  func setIdCompany(value: Int) {
    UserDefaults.standard.set(value, forKey: idCompany)
  }
  
  func getIdCompany() -> Int? {
    return UserDefaults.standard.integer(forKey: idCompany)
  }

  func setNameCompany(value: String) {
    UserDefaults.standard.set(value, forKey: nameCompany)
  }
  
  func getNameCompany() -> String? {
    return UserDefaults.standard.string(forKey: nameCompany)
  }

  func setInitialIncomesCompany(value: Float) {
    UserDefaults.standard.set(value, forKey: initialIncomesCompany)
  }
  
  func getInitialIncomesCompany() -> Float? {
    return UserDefaults.standard.float(forKey: initialIncomesCompany)
  }

  func setInitialExpensesCompany(value: Float) {
    UserDefaults.standard.set(value, forKey: initialExpensesCompany)
  }
  
  func getInitialExpensesCompany() -> Float? {
    return UserDefaults.standard.float(forKey: initialExpensesCompany)
  }

  func setImageCompany(value: String) {
    UserDefaults.standard.set(value, forKey: imageCompany)
  }
  
  func getImageCompany() -> String? {
    return UserDefaults.standard.string(forKey: imageCompany)
  }

  func setBalanceCompany(value: Float) {
    UserDefaults.standard.set(value, forKey: balanceCompany)
  }
  
  func getBalanceCompany() -> Float? {
    return UserDefaults.standard.float(forKey: balanceCompany)
  }

  func setCreatedAtCompany(value: String) {
    UserDefaults.standard.set(value, forKey: createdAtCompany)
  }
  
  func getCreatedAtCompany() -> String? {
    return UserDefaults.standard.string(forKey: createdAtCompany)
  }

  func setUpdatedAtCompany(value: String) {
    UserDefaults.standard.set(value, forKey: updatedAtCompany)
  }
  
  func getUpdatedAtCompany() -> String? {
    return UserDefaults.standard.string(forKey: updatedAtCompany)
  }
  
  func removeSession(){
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    
    dictionary.keys.forEach
      { key in defaults.removeObject(forKey: key)
    }
  }
}
