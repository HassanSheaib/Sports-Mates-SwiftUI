//
//  LocationRowView.swift
//  SportMates
//
//  Created by HHS on 27/09/2022.
//

import SwiftUI
import CoreLocation

struct LocationRowView: View {
    
    var cityName: String
    var gouvernate: String
    var country : String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Spacer()
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "mappin.and.ellipse")
                VStack{
                    Text("City")
                    Text(cityName).lineLimit(1)
                }
                
            }
            Spacer()

            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "map")
                VStack{
                    Text("Gouvernate").lineLimit(1)
                    Text(gouvernate).lineLimit(1)
                }
            }
            Spacer()

            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "globe.central.south.asia.fill")
                VStack{
                    Text("Country")
                    Text(country).lineLimit(1)
                }
            }
            Spacer()

        }
        .font(.footnote)
        .foregroundColor(Color.gray)
        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
        .padding(.horizontal)
        .background(Color("ColorBlackLight"))
        .cornerRadius(12)
    }
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(cityName: "hassan", gouvernate: "hussein", country: "Sheaib")
    }
}
