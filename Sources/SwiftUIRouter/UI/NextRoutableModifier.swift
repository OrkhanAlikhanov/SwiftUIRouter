//
//  NextRoutableModifier.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 1/25/21.
//

import SwiftUI

public struct NextRoutableModifier: ViewModifier {
  @Environment(\.router) var router
  @Environment(\.presentationMode) var presentationMode

  @State var current: ResolvedRoute
  @State var next: ResolvedRoute?
  @State var isActive: Bool = false
  
  @ViewBuilder
  public var nextView: some View {
    if let next = next {
      next.view
    } else {
      EmptyView()
    }
  }
  
  public func body(content: Content) -> some View {
    VStack(spacing: 0) {
      content
      NavigationLink(destination: nextView, isActive: $isActive) {
        EmptyView()
      }
      .onReceive(current.$meta) { _ in
        if (current.meta["nativePop"] as? Bool) == true {
          presentationMode.wrappedValue.dismiss()
          return
        }

        if let nextRoute = current.next {
          if (nextRoute.meta["isRouterLink"] as? Bool) != true {
            next = nextRoute
            isActive = true
          }
        } else {
          next = nil
          isActive = false
        }
      }
      .onChange(of: isActive) { isActive in
        guard isActive == false else {
          return
        }

        router.pop(till: current, native: false)
      }
    }
  }
}

extension View {
  func nextRoutable(current: ResolvedRoute) -> some View {
    modifier(NextRoutableModifier(current: current))
  }
}
