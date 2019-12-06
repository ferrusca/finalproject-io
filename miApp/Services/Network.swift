//
//  Network.swift
//  miApp
//

import Foundation
class Network {
  var components = URLComponents()
  init() {
    components.scheme = "http"
    components.host = "54.152.14.129"
    components.port = 1234
  }
}
