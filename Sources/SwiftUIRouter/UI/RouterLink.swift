//
//  RouterLink.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/25/21.
//

import SwiftUI

public struct RouterLink<Content: View>: View {
  @Environment(\.router) var router

  public var link: NavigationRouteLink
  public let content: Content
  
  @State var isActive = false
  @State var route: ResolvedRoute?
  
  public init(_ link: NavigationRouteLink, @ViewBuilder content: () -> Content) {
    self.link = link
    self.content = content()
  }
  
  @ViewBuilder
  public var nextView: some View {
    if let route = route {
      route.view
    } else {
      EmptyView()
    }
  }
  
  public var body: some View {
    NavigationLink(destination: nextView, isActive: $isActive) {
      content
    }
    .onDismantle(perform: pop)
    .onChange(of: isActive) { isActive in
      if isActive == true, route == nil {
        route = router.push(link: link, meta: ["isRouterLink": true])
      }
      
      if isActive == false {
        pop()
      }
    }
  }
  
  public func pop() {
    guard let r = route?.previous else {
      return
    }
    
    route = nil
    router.pop(till: r, native: false)
  }
}
