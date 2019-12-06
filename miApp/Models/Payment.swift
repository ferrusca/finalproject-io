import Foundation
struct Payment: Decodable, Encodable {
  var id: Int? = nil
  var name: String
  var product_name: String
  var product_amount: Float
  var date_of_pay: String? = ""
  var state: Bool? = false
  var updatedAt: String? = ""
  var createdAt: String? = ""

  init(name: String,
      product_name: String,
      product_amount: Float,
      date_of_pay: String,
      state: Bool) {
    self.name = name
    self.product_name = product_name
    self.product_amount = product_amount
    self.date_of_pay = date_of_pay
    self.state = state
  }
  
  init(id: Int,
       name: String,
       product_name: String,
       product_amount: Float,
       date_of_pay: String,
       state: Bool) {
    self.id = id
    self.name = name
    self.product_name = product_name
    self.product_amount = product_amount
    self.date_of_pay = date_of_pay
    self.state = state
  }
}
