//
//  LocationModel.swift
//  SportMates
//
//  Created by HHS on 26/09/2022.
//

import Foundation
import MapKit


struct LocationModal {
    var cityName: String
    var gouvernate : String
    var country: String
    var coordinate : CLLocationCoordinate2D
    
}

struct MapPinLocation: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
