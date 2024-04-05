//
//  GuideComponent.swift
//  SportMates
//
//  Created by HHS on 25/10/2022.
//

import SwiftUI

struct GuideComponent: View {
    var title: String
    var description: String
    var icon: String
    
    var body: some View {
      HStack(alignment: .center, spacing: 20) {
        Image(systemName: icon)
          .font(.largeTitle)
          .foregroundColor(Color.accentColor)
        
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text(title.uppercased())
              .font(.title3)
              .fontWeight(.heavy)
            Spacer()

          }
          Divider().padding(.bottom, 4)
          Text(description)
            .font(.footnote)
            .foregroundColor(.white )
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
  }
struct GuideComponent_Previews: PreviewProvider {
    static var previews: some View {
        GuideComponent(title: "Hey Love", description: "i dont know much", icon: "zehahahha")
    }
}
