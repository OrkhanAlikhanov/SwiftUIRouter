//
//  ResolvedRoute.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/25/21.
//

import SwiftUI

public class ResolvedRoute: ObservableObject {
  public var route: NavigationRoute
  public var link: NavigationRouteLink
  public var params: [String: String]
  private var prepareView: (_ view: AnyView, _ route: ResolvedRoute) -> AnyView
  private var _cachedView: AnyView?
  
  @Published
  public var meta: [String: Any] = [:]
  
  public var view: AnyView {
    if _cachedView == nil {
      let view =  route.content(self)
      _cachedView = prepareView(view, self)
    }
    
    return _cachedView!
  }
  
  
  public init(route: NavigationRoute, link: NavigationRouteLink, params: [String: String], prepareView: @escaping (AnyView, ResolvedRoute) -> AnyView) {
    self.route = route
    self.link = link
    self.params = params
    self.prepareView = prepareView
  }
}

extension ResolvedRoute: Equatable {
  public static func ==(lhs: ResolvedRoute, rhs: ResolvedRoute) -> Bool {
    lhs.link == rhs.link
  }
}

extension ResolvedRoute {
  func updateMeta(key: String, value: Any?) {
    meta[key] = value
    meta = { meta }()
  }
}
