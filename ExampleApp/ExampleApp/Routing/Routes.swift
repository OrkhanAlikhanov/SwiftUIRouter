//
//  User.swift
//  
//
//  Created by Orkhan Alikhanov on 6/1/21.
//

import SwiftUIRouter

extension NavigationRouteLink {
  static var login: NavigationRouteLink { "/login" }
  static var signUp: NavigationRouteLink { "/register" }
  
  static func userDetails(for user: User) -> NavigationRouteLink {
    NavigationRouteLink(path: "/users/\(user.id)", meta: [
      "user": user,
    ])
  }
  
  static func userDetails(for id: Int) -> NavigationRouteLink {
    NavigationRouteLink(path: "/users/\(id)")
  }
}

extension Array where Element == NavigationRoute {
  static var all: [NavigationRoute] {
    let login = NavigationRoute(path: "/login", destination: LoginPage())
    let register = NavigationRoute(path: "/register", destination: RegisterPage())
    let user = NavigationRoute(path: "/users/{id}") { route in
      UserPage(user: route.meta("user") ?? User(id: route.int("id"), name: "Unknown"))
    }

    return [login, register, user]
  }
}

private extension ResolvedRoute {
  func int(_ param: String) -> Int {
    Int(params[param] ?? "") ?? -1
  }
  
  func string(_ param: String) -> String {
    params[param] ?? ""
  }
  
  func meta<T>(_ param: String) -> T? {
    link.meta[param] as? T
  }
}
