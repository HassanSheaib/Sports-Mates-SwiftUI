//
//  HeaderComponent.swift
//  SportMates
//
//  Created by HHS on 25/10/2022.
//

import SwiftUI

struct HeaderComponent: View {
    var body: some View {
      VStack(alignment: .center, spacing: 20) {

          ZStack{
              Text("S p o r t s   M a t e s ")
                  .font(.largeTitle)
                  .fontWeight(.bold)
                  .foregroundColor(.white)
                  .italic()
              
              Capsule()
                .frame(height: 3)
                .foregroundColor(Color.black)
                .opacity(1)
                .offset(y: 1)
              
          }
      }
    }
    }

struct HeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        HeaderComponent()
    }
}


