//
//  button.backgroundColor = .clear button.layer.cornerRadius = 5 button.layer.swift
//  miApp
//
//  Created by 2020-1 on 11/25/19.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class MyButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  func setUp(){
    self.backgroundColor = .clear
    self.layer.cornerRadius = 8
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.darkGray.cgColor
  }

}
