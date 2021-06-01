//
//  NavigationRouter.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/25/21.
//

import SwiftUI

public class NavigationRouter {
  public var routeStack: [ResolvedRoute] = []
  public var registeredRoutes: [NavigationRoute] = []
  public var prepareRouteView: (_ view: AnyView, _ route: ResolvedRoute) -> AnyView
  public var didUpdateRouteStack: () -> Void
  
  private var routeData: [String: (paramNames: [String], regexPattern: String)] = [:]
  
  public init(routes: [NavigationRoute]) {
    registeredRoutes = routes
    didUpdateRouteStack = { }
    prepareRouteView = { AnyView($0.nextRoutable(current: $1)) }
  }
  
  @discardableResult
  public func push(link: NavigationRouteLink, meta: [String: Any] = [:]) -> ResolvedRoute? {
    guard let $route = resolve(link: link) else {
      return nil
    }
    
    $route.meta = meta
    
    let last = routeStack.last
    routeStack.append($route)
    
    last?.next = $route
    $route.previous = last
    
    didUpdateRouteStack()
    return $route
  }
  
  public func pop(native: Bool = true) {
    if native {
      routeStack.last?.nativePop()
      return
    }
    
    routeStack.removeLast()
    routeStack.last?.next = nil
    didUpdateRouteStack()
  }
  
  public func pop(till: ResolvedRoute, native: Bool = true) {
    guard let i = routeStack.firstIndex(of: till) else {
      return
    }

    if native {
      routeStack[i...].dropFirst().reversed().forEach {
        $0.nativePop()
      }
      return
    }

    /// Reset state so that subscribers are notified. This is added because we
    /// adjust global tab bar state based on `previouslyDisabledGlobal` on a subscriber.
    routeStack[i...].dropFirst().reversed().forEach { route in
      route.previous = nil
      route.next = nil
    }

    routeStack = Array(routeStack[...i])
    routeStack.last?.next = nil
    didUpdateRouteStack()
  }
}

public extension NavigationRouter {
  func resolve(link: NavigationRouteLink) -> ResolvedRoute? {
    for route in registeredRoutes {
      var v = routeData[route.path]
      
      if v == nil {
        v = (
          try! Utils.Regex.matches(route.path, pattern: "\\{(.+?)\\}"),
          try! Utils.Regex.replace(route.path, pattern: "\\{.+?\\}", with: "\\([^/]+\\)\\/\\?").replacingOccurrences(of: "/", with: "\\/") + "$"
        )
      }
      
      let (paramNames, regexPattern) = v!
      
      let params = try! Utils.Regex.matches(link.path, pattern: regexPattern)
      if params.isEmpty {
        guard route.path == link.path else {
          continue
        }
        
        return ResolvedRoute(route: route, link: link, params: [:], prepareView: prepareRouteView)
      }
      
      guard params.count == paramNames.count else {
        // this should not happen actually
        continue
      }
      
      var routeParams = [String: String]()
      zip(paramNames, params).forEach {
        routeParams[$0] = Utils.URL.unescape($1)
      }
      
      return ResolvedRoute(route: route, link: link, params: routeParams, prepareView: prepareRouteView)
    }
    
    return nil
  }
}

private enum Utils {
  enum Regex {
    static func replace(_ string: String, pattern: String, with template: String) throws -> String {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      return regex.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length: string.count), withTemplate: template)
    }
    
    static func matches(_ string: String, pattern: String) throws -> [String] {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
      var matches = [String]()
      let string = NSString(string: string) //for NSString.substring
      results.forEach { result in
        (1..<result.numberOfRanges).forEach {
          matches.append(string.substring(with: result.range(at: $0)))
        }
      }
      return matches
    }
  }
  
  enum URL {
    static func unescape(_ url: String) -> String {
      let url = url.replacingOccurrences(of: "+", with: " ")
      return url.removingPercentEncoding ?? url
    }
    
    static func decode(_ url: String) -> [String: String] {
      let url = unescape(url)
      var params = [String: String]()
      let keyValues = url.split(separator: "&")
      keyValues.forEach { keyValue in
        let pair = keyValue.split(separator: "=", maxSplits: 1)
        // if split string misses `=` for some reason (eg. example.com/api?test), we put empty string as its value
        let (key, value) = (pair[0], pair.count == 2 ? pair[1] : "")
        params[String(key)] = String(value)
      }
      
      return params
    }
  }
}


public extension ResolvedRoute {
  var previous: ResolvedRoute? {
    get { meta["previous"] as? ResolvedRoute }
    set { updateMeta(key: "previous", value: newValue) }
  }

  var next: ResolvedRoute? {
    get { meta["next"] as? ResolvedRoute }
    set { updateMeta(key: "next", value: newValue) }
  }
}

private extension ResolvedRoute {
  func nativePop() {
    updateMeta(key: "nativePop", value: true)
  }
}

private struct NavigationRouterEnvironmentKey: EnvironmentKey {
  static var defaultValue = NavigationRouter(routes: []) // empty router
}

public extension EnvironmentValues {
  var router: NavigationRouter {
    get { self[NavigationRouterEnvironmentKey.self] }
    set { self[NavigationRouterEnvironmentKey.self] = newValue }
  }
}
