//
//  MapAnnotationView.swift
//  SportMates
//
//  Created by HHS on 03/10/2022.
//

import SwiftUI

struct MapAnnotationView: View {
    
    @State private var  animation: Double = 0.0
    @State var image: String
    var body: some View {
        
        ZStack {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 24, height: 24, alignment: .center)
            
            Circle()
                .stroke(Color.accentColor, lineWidth: 2)
                .frame(width: 34, height: 34, alignment: .center)
                .scaleEffect(1 + CGFloat(animation))
                .opacity(1 - animation)
            
            Image("rug")
                .resizable()
                .scaledToFit()
                .frame(width: 34, height: 34, alignment: .center)
                .clipShape(Circle())
        }
        .onAppear{
            withAnimation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false)){
                animation = 1
            }
        }
        
    }
}

struct MapAnnotationView_Previews: PreviewProvider {

    static var previews: some View {
        MapAnnotationView(image: "football1")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
