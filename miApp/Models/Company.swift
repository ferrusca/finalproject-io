import Foundation
struct Company: Decodable, Encodable {
  var id: Int? = nil
  var name: String
  var initial_incomes: Float
  var initial_expenses: Float
  var image: String? = ""
  var balance: Float
  var UserId: Int? = nil
  var createdAt: String? = nil
  var updatedAt: String? = nil
  
  init(name: String,
    initial_incomes: Float,
    initial_expenses: Float,
    balance: Float,
    UserId: Int,
    image: String
    ) {
    self.name = name
    self.initial_incomes = initial_incomes
    self.initial_expenses = initial_expenses
    self.balance = balance
    self.UserId = UserId
    self.image = image
  }     
  
}
