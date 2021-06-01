//
//  OnDismantle.swift
//  Oxuyan
//
//  Created by Orkhan Alikhanov on 3/14/21.
//

import SwiftUI
import UIKit

extension View {
  func onDismantle(perform: @escaping () -> Void) -> some View {
    background(DismantleObserver(onDismantle: perform))
  }
}

private struct DismantleObserver: UIViewRepresentable {
  let onDismantle: () -> Void
  
  func makeUIView(context: Context) -> UIView { UIView() }
  
  func updateUIView(_ uiView: UIView, context: Context) {}
  
  func makeCoordinator() -> ClosureHolder {
    ClosureHolder(closure: onDismantle)
  }
  
  static func dismantleUIView(_ uiView: UIView, coordinator: ClosureHolder) {
    coordinator.closure()
  }
}

private class ClosureHolder {
  let closure: () -> Void
  
  init(closure: @escaping () -> Void) {
    self.closure = closure
  }
}
