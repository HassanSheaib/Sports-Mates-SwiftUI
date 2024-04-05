//
//  InsetMapView.swift
//  SportMates
//
//  Created by HHS on 23/09/2022.
//

import SwiftUI
import MapKit

struct InsetMapView: View {
    
    
    //MARK: Proprities
    @StateObject private var addGameVM = AddAndDeleteGamesViewModel()

    //Location Proprities
    @State var iconImage : String
    @State var locationEnabled = true
    @State var reg = MKCoordinateRegion()
    @Binding var location : [MapPinLocation]
    @Binding var showMapView : Bool
    
    // Animation Proprities
    @State var showActivityIndicator = true
    @State private var pulsate: Bool = false
    
    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
            .speed(1)
            .delay(0.25)
    }
    
    
    //MARK: FUNCTIONS

    
    func getUserLocationAndAdress(){        
        LocationManager.shared.getCurrentReverseGeoCodedLocation { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
            
            if let error = error {
                print("error in Reverse GeoCoding \(error.localizedDescription)")
                if error.localizedDescription ==  LocationManager.LocationErrors.denied.rawValue {
                    locationEnabled = false
                }
                return
            }
            
            guard let location = location else {
                return
            }
            self.reg = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude:  location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
        
    }
    
    
    
    //MARK: VIEW
    
    var body: some View {
        
        if reg.center.longitude == 0 && locationEnabled == true{
            Spinner()
                .task {
                    self.getUserLocationAndAdress()
                    }
        }else if !locationEnabled{
            Spacer()
            VStack{
                Image(systemName: "location.slash.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
                Text("The App need access to your current location!!")
            }
            Spacer()
            
        }else{
            ZStack {
                Map(coordinateRegion: $reg, showsUserLocation: true, annotationItems: self.location ) { location in
                    
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        VStack {
                            MapAnnotationView(image: iconImage)
                            Text(location.name)
                        }
                    }
                }

                Image(systemName: "mappin")
                    .foregroundColor(.accentColor)
                    .frame(width: 52, height: 52)

                VStack {
                    Spacer()
                    HStack {
                        Button {
                            if !self.location.isEmpty{
                                self.location.removeLast()
                            }else{
                                print("its empty")
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding()
                                .font(.title)
                                .foregroundColor(Color.red)
                                .shadow(radius: 4)
                                .opacity(self.pulsate ? 1 : 0.6)
                                .scaleEffect(self.pulsate ? 1.8 : 0.8, anchor: .center)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
                        }
                        
                        
                        Spacer()
                        Button {
                            let newLocation = MapPinLocation(id: UUID(), name: "Game Location", description: "", latitude: reg.center.latitude, longitude: reg.center.longitude)
                            if self.location.isEmpty{
                                self.location.append(newLocation)
                            }else{
                                print("only allwed to set 1 location")
                            }
                            
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .padding()
                                .font(.title)
                                .foregroundColor(Color.green)
                                .shadow(radius: 4)
                                .opacity(self.pulsate ? 1 : 0.6)
                                .scaleEffect(self.pulsate ? 1.8 : 0.8, anchor: .center)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
                        }
                    }
                }.padding()
            }
            .overlay(
                HStack (spacing: 20){
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            self.showMapView.toggle()
                        }, label: {
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .shadow(radius: 4)
                                .opacity(self.pulsate ? 1 : 0.6)
                                .scaleEffect(self.pulsate ? 1.2 : 0.8, anchor: .center)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
                        })
                        .padding(.trailing, 20)
                        .padding(.top, 24)
                        Spacer()
                    }
                    
                }.padding()
            )
            .onAppear() {
                
                self.pulsate.toggle()
                
            }
        }
        
        
    }
}
