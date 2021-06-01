//
//  NavigationRouteLink.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/25/21.
//

import SwiftUI

public struct NavigationRouteLink {
  public var id = UUID()
  public var path: String
  public var meta: [String: Any]
  
  public init(path: String, meta: [String: Any] = [:]) {
    self.path = path
    self.meta = meta
  }
}

extension NavigationRouteLink: ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) {
    self.init(path: value)
  }
}

extension NavigationRouteLink: Equatable {
  public static func ==(lhs: NavigationRouteLink, rhs: NavigationRouteLink) -> Bool {
    lhs.id == rhs.id
  }
}

extension NavigationRouteLink: Hashable {
  public func hash(into hasher: inout Hasher) {
    id.hash(into: &hasher)
  }
}
