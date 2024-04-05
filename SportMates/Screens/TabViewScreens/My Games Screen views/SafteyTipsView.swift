//
//  SafteyTipsView.swift
//  SportMates
//
//  Created by HHS on 08/10/2022.
//

import SwiftUI

struct SafteyTipsView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .foregroundColor(Color.red)
                
                Text("Saftey Tips".uppercased())
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Text("Be CareFul".uppercased())
                  .font(.title3)
                  .fontWeight(.heavy)
                  .foregroundColor(Color.red)
                
            }
        
            Divider().padding(.bottom, 4)
            Text("Make sure to check that the game location is a Sports center.")
                .foregroundColor(.white)
                .font(.footnote)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider().padding(.bottom, 4)
            Text("Do not join games that are very late.")
                .foregroundColor(.white)
                .font(.footnote)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color("ColorBlackLight") )
        .cornerRadius(12)
        .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 0)
    }
}

struct SafteyTipsView_Previews: PreviewProvider {
    static var previews: some View {
        SafteyTipsView()
    }
}
