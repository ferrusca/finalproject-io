//
//  Date.swift
//  miApp
//
//  Created by 2020-1 on 11/25/19.
//  Copyright © 2019 ios. All rights reserved.
//

import Foundation
struct MyDate {
  // choose which date and time components are needed
  static let requestedComponents: Set<Calendar.Component> = [
    .year,
    .month,
    .day,
    .hour,
    .minute,
    .second
  ]
}
