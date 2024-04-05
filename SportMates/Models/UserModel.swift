//
//  UserModel.swift
//  SportMates
//
//  Created by HHS on 26/09/2022.
//

import Foundation


struct UserModel: Codable, Identifiable {
    var id : String
    var email: String
    var provider: String
    var name: String
    var yearOfBirth: String
    var gender: String
    var joinedGamesUUID : [String]
    var gamesChatroomsUUIDs : [String]
    
    var age: Int {
        
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: todayDate)
        let age = Int(yearString)! - Int(yearOfBirth)!
        return age
    }

}
