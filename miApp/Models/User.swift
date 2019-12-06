import Foundation
struct User: Decodable, Encodable {
  var id: Int? = nil // it can be changed
  let name: String
  let username: String
  let email: String
  var password: String? = nil // it can be changed
  init(name: String, username: String, email: String, password: String) {
    self.name=name
    self.username=username
    self.email=email
    self.password=password
  }
}

struct UserTryLogin: Encodable {
  let email: String
  let password: String
}

struct Auth: Decodable {
  let token: String
}
