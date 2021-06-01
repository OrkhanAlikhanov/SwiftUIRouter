//
//  RegisterPage.swift
//  
//
//  Created by Orkhan Alikhanov on 6/1/21.
//

import SwiftUI
import SwiftUIRouter

struct RegisterPage: View {
  @Environment(\.router) var router
  
  var body: some View {
    VStack {
      RouterLink(.login) {
        Text("Have an acccount? Login here")
      }
      .padding()
      
      RouterLink("/login") {
        Text("Have an acccount? Login here 2")
      }
      .padding()
      
      Button("Pop") {
        router.pop()
      }
      .padding()
    }
    .navigationTitle("Register")
  }
}
