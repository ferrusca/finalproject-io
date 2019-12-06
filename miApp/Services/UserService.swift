//UsrService


import Foundation
class UserService: Network {
  static let userService: UserService = UserService()
  //  MARK: AUTH USER
  class func auth(
    email: String,
    password: String,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void
  ) {
    userService.components.path = "/token"
    
    var req = URLRequest(url: userService.components.url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let user = UserTryLogin(email: email, password: password)
    let data = try! JSONEncoder().encode(user)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }
  
  //  MARK: CREATE USER
  class func create(
    name: String,
    username: String,
    email: String,
    password: String,
    _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    userService.components.path = "/users"
    
    var req = URLRequest(url: userService.components.url!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let user = User(name: name, username: username, email: email, password: password)
    let data = try! JSONEncoder().encode(user)
    req.httpBody = data
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
  }
  //  MARK: CURRENT USER
  class func currentUser(_ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    userService.components.path = "/user"
    
    var req = URLRequest(url: userService.components.url!)
    req.httpMethod = "GET"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue("JWT \(SessionHelper().isLoggedIn() ?? "without-token")", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: req, completionHandler: completion)
    task.resume()
    
  }
  
  class func storeToken(_ data: Data?, completion: @escaping (Auth) -> Void) -> Void {
    guard let data = data else { return }
    let decoder = JSONDecoder()
    do {
      let json = try decoder.decode(Auth.self, from: data)
      DispatchQueue.main.async {
        completion(json)
      }
    } catch let err {
      print("Parsing Error: \(err)")
    }
  }
}
