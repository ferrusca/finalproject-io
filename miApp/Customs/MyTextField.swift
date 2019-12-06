//
//  UnderLine.swift
//  miApp
//
//  Created by 2020-1 on 11/25/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class MyTextField: UITextField {

  let padding = UIEdgeInsets(top: 7, left: 2, bottom: 7, right: 2)
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  func setUp() {
    self.layer.backgroundColor = UIColor.lightGray.cgColor
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 0.9
    self.layer.shadowRadius = 0.1
    self.layer.cornerRadius = 5
  }

}
