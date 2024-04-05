//
//  HeaderView.swift
//  SportMates
//
//  Created by HHS on 22/09/2022.
//



import SwiftUI

struct HeaderView: View {
  // MARK: - PROPERTIES
    var title :String
    var note: String
    var color: Color
    var image: String
  
  @State private var showHeadline: Bool = false
  
  var slideInAnimation: Animation {
    Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
      .speed(1)
      .delay(0.25)
  }
  
  var body: some View {
    ZStack {
      Image(image)
        .resizable()
        .aspectRatio(contentMode: .fill)

      
      HStack(alignment: .top, spacing: 0) {
        Rectangle()
              .fill(Color.accentColor)
              .frame(width: 4)
        
        VStack(alignment: .leading, spacing: 6) {
          Text(title)
            .font(.system(.title, design: .serif))
            .fontWeight(.bold)
            .foregroundColor(color)
            .shadow(radius: 3)
          
          Text(note)
            .font(.footnote)
            .lineLimit(4)
            .multilineTextAlignment(.leading)
            .foregroundColor(color)
            .shadow(radius: 3)
        }
        .padding(.vertical, 0)
        .padding(.horizontal, 20)
        .frame(width: 281, height: 105)
        .background(Color("ColorBlackTransparentDark"))
      }
      .frame(width: 285, height: 105, alignment: .center)
      .offset(x: -40, y: showHeadline ? 25 : 120)
      .animation(slideInAnimation, value: showHeadline)
      .onAppear(perform: {
        showHeadline = true
      })
      .onDisappear(perform: {
        showHeadline = false
      })
    }
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)

  }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Available Games", note: "Choose the game that you like, don't forget to double check the Game time and location. Be There On Time!!", color: .white, image: "Basketball")
    }
}
