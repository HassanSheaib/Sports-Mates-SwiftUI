//
//  Helpers.swift
//  SportMates
//
//  Created by HHS on 18/09/2022.
//

import Foundation
import SwiftUI



struct IconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 35, height: 35, alignment: .center)
            .clipShape(Circle())
        
    }
}
struct IconCustomizer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 30, height: 30, alignment: .center)
            .clipShape(Circle())
        
    }
}

struct ButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .padding()
      .frame(minWidth: 0, maxWidth: .infinity)
      .background(Capsule().fill(Color.pink))
      .foregroundColor(Color.white)
  }
}


extension View {
    public func alert<Value>(
        using value: Binding<Value?>,
        content: (Value) -> Alert
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return alert(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
}
