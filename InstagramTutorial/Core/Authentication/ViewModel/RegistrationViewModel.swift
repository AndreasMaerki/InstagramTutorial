import Foundation

class RegistrationViewModel: ObservableObject {
  @Published var userName = ""
  @Published var email = ""
  @Published var password = ""

  func createUser() async throws {
    try await AuthService.shared.createUser(email: email, password: password, userName: userName)
    clearData()
  }

  private func clearData() {
    userName = ""
    email = ""
    password = ""
  }
}