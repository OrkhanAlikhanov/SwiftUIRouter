//
//  NavigationRoute.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/25/21.
//

import SwiftUI

public struct NavigationRoute {
  public let path: String
  public let content: (ResolvedRoute) -> AnyView
  
  public init<V: View>(path: String, destination: @escaping (ResolvedRoute) -> V) {
    self.path = path
    content = { AnyView(destination($0)) }
  }
}

extension NavigationRoute {
  public init<V: View>(path: String, destination: @escaping () -> V) {
    self.init(path: path, destination: { _ in destination() })
  }
  
  public init<V: View>(path: String, destination: @autoclosure @escaping () -> V) {
    self.init(path: path, destination: { _ in destination() })
  }
}
