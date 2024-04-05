//
//  DetailScreenMapView.swift
//  SportMates
//
//  Created by HHS on 27/09/2022.
//

import SwiftUI
import MapKit

struct DetailScreenMapView: View {
    var game: GameViewModel
    @State var reg = MKCoordinateRegion()
    @State var locations : [MapPinLocation]

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Map(coordinateRegion: $reg, showsUserLocation: true,  annotationItems: self.locations ) { location in
                
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    VStack {
                        MapAnnotationView(image: game.sportName)
                        Text(location.name)
                    }.onTapGesture {
                        print(location.latitude)
                        print(location.longitude)

                        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(location.latitude),\(location.longitude)&directionsmode=driving")
                        if UIApplication.shared.canOpenURL(url!) {
                              UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                        else{
                            let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(location.latitude),\(location.longitude)&directionsmode=driving")
                                        
                               UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        .task {
            self.reg = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: game.locationLatitude, longitude: game.locationLongitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 0)

    }
}

//struct DetailScreenMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailScreenMapView(game: GameViewModal(game: data[3]), locations: [MapPinLocation(id: UUID(), name: "Hello", description: "Hello", latitude: 0.3557555656, longitude: 0.38656567)])
//    }
//}
