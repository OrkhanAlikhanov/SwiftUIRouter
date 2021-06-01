//
//  RouterView.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/27/21.
//

import SwiftUI

public struct RouterView: View {
  @Environment(\.router) var router
  public var link: NavigationRouteLink
  
  public init(_ link: NavigationRouteLink) {
    self.link = link
  }
  
  public var body: some View {
    if let route = router.resolve(link: link) {
      route.view
    } else {
      EmptyView()
    }
  }
}
