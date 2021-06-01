//
//  RouterView.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/27/21.
//

import SwiftUI

public struct RouterView: View {
  public var router: NavigationRouter
  
  public init(router: NavigationRouter, root: NavigationRouteLink? = nil) {
    self.router = router
    
    guard  let link = root else {
      return
    }
    
    guard let route = router.resolve(link: link) else {
      print("[RouterView: Given root link not found: \(link.path)]")
      return
    }
    
    router.routeStack.append(route)
  }
  
  public var body: some View {
    if let route = router.routeStack.first {
      route
        .view
        .environment(\.router, router)
    } else {
      EmptyView()
    }
  }
}
