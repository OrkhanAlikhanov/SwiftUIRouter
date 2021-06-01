//
//  ExampleApp.swift
//  
//
//  Created by Orkhan Alikhanov on 6/1/21.
//

import SwiftUI
import SwiftUIRouter

struct ExampleApp: View {
  var body: some View {
    NavigationView {
      RouterView(router: .main, root: .login)
    }
    /// I don't know why, but setting \.router in RouterView itself was not enough. Probably NavigationView
    /// overrides environment of its children somehow. So we set \.router environment again
    .environment(\.router, .main)
    
    /// This is important because default one (DoubleColumnNavigationViewStyle) is
    /// updating NavigationLink.$isActive inconsistently
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

extension NavigationRouter {
  static var main = NavigationRouter(routes: .all)
}


struct ExampleApp_Previews: PreviewProvider {
  static var previews: some View {
    ExampleApp()
  }
}
