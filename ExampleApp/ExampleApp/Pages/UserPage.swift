//
//  UserPage.swift
//  
//
//  Created by Orkhan Alikhanov on 6/1/21.
//

import SwiftUI

struct UserPage: View {
  @Environment(\.router) var router
  @State var user: User
    
  var body: some View {
    VStack {
      VStack {
        Text("#\(user.id)")
        Text(user.name)
        
        if let surname = user.surname {
          Text(surname)
        } else {
          ProgressView()
        }
      }
    
    
      Button("Pop") {
        router.pop()
      }
      .padding()
    }
    .navigationTitle("User \(user.name)")
    .onAppear {
      /// Fetch user data based on user.id
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        user.surname = "Alikhanov"
      }
    }
  }
}
