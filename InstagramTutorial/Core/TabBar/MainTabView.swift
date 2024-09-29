//
//  MainTabView.swift
//  InstagramTutorial
//
//  Created by Andreas Maerki on 25.04.24.
//

import SwiftUI

struct MainTabView: View {
  let user: User
  
  @State private var selectedIndex = 0
  var body: some View {
    TabView(selection: $selectedIndex) {
      FeedView()
        .tabItem {
          Image(systemName: "house")
        }
        .tag(0)
      SearchView()
        .tabItem {
          Image(systemName: "magnifyingglass")
        }
        .tag(1)
      UploadPostView(tabIndex: $selectedIndex)
        .tabItem {
          Image(systemName: "plus.square")
        }
        .tag(2)
      Text("Notifications")
        .tabItem {
          Image(systemName: "heart")
        }
        .tag(3)
      NavigationStack {
        ProfileView(isCurrentUserProfile: true, user: user)
      }
      .tabItem {
        Image(systemName: "person")
      }
      .tag(4)
    }
    .accentColor(.black)
  }
}

#Preview {
  MainTabView(user: User.MOCK_USERS.first!)
}