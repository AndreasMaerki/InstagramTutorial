import _PhotosUI_SwiftUI
import Firebase
import SwiftUI

@MainActor
class EditProfileViewModel: ObservableObject {
  @Published var user: User
  @Published var fullName = ""
  @Published var bio = ""
  @Published var profileImage: Image?
  @Published var selectedImage: PhotosPickerItem? {
    didSet {
      Task {
        await loadImage(fromItem: selectedImage)
      }
    }
  }

  private var uiImage: UIImage?

  init(user: User) {
    self.user = user

    if let fullName = user.fullName {
      self.fullName = fullName
    }

    if let bio = user.bio {
      self.bio = bio
    }
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard
      let item = item,
      let data = try? await item.loadTransferable(type: Data.self),
      let uiImage = UIImage(data: data)
    else { return }
    self.uiImage = uiImage
    profileImage = Image(uiImage: uiImage)
  }

  func updateUserData() async throws {
    var data = [String: Any]()

    if let uiImage {
      let imageUrl = try? await ImageUploader.upload(image: uiImage)
      data["profileImageUrl"] = imageUrl
    }

    if !fullName.isEmpty && fullName != user.fullName {
      data["fullName"] = fullName
    }

    if !bio.isEmpty && bio != user.bio {
      data["bio"] = bio
    }

    if !data.isEmpty {
      try await Firestore.firestore().collection("users").document(user.id).updateData(data)
    }
  }
}
