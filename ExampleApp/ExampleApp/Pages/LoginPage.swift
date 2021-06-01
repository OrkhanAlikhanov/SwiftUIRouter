//
//  LoginPage.swift
//  
//
//  Created by Orkhan Alikhanov on 6/1/21.
//

import SwiftUI
import SwiftUIRouter

struct LoginPage: View {
  @Environment(\.router) var router
  @State var isLoggingIn = false
  
  var body: some View {
    VStack {
      RouterLink(.signUp) {
        Text("Don't have an acccount? Register here")
      }
      .padding()
      
      HStack {
        if isLoggingIn {
          ProgressView()
        }
        
        Button("Log in") {
          isLoggingIn = true
          /// After logging in, go to details page
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoggingIn = false
            router.push(link: .userDetails(for: .init(id: 1, name: "Orkhan")))
          }
        }
      }
      .padding()
    }
    .navigationTitle("Login")
  }
}
