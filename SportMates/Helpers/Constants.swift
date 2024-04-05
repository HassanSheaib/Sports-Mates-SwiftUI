//
//  Constants.swift
//  SportMates
//
//  Created by HHS on 19/09/2022.
//

import Foundation




// MARK: - Games DATA



struct Constants {
    let gamesArray = ["Football", "Basketball", "Table Tennis", "Tennis", "Pool", "Vollyball", "Badminton", "Golf", "Cycling", "Boxing", "Cricket", "Rugby", "American Football", "Darts", "Bowling"]
    
    let gamesForFilter = ["All","Football", "Basketball", "Table Tennis", "Tennis", "Pool", "Vollyball", "Badminton", "Golf", "Cycling", "Boxing", "Cricket", "Rugby", "American Football", "Darts", "Bowling"]
    
    let purposesForFilter = ["Any", "For Fun", "Burn Some Calories" ,"Competition", "Life or Death"]
    let playersLevelForFilter = ["Any", "Beginners", "Intermediates", "Professionals", "Doesn't Matter"]
    
    let durations = ["1hr", "1hr:30min", "2hr", "2hrs:30min", "3hrs", "Undefined"]
    let purposes = ["For Fun", "Burn Some Calories" ,"Competition", "Life or Death"]
    let playersLevel = ["Beginners", "Intermediates", "Professionals", "Doesn't Matter"]
    
    let distanceRange = ["10", "15", "30", "50", "100" ]
    
    var numberOfPlayers : [String] {
        var players = [String]()
        for index in 2...22 {
            let stringNumber = String(index)
            players.append(stringNumber)
        }
        return players
    }
    var yearsRange : [String] {
        var yearsArry = [String]()
        for index in 1950...2022 {
            let stringNumber = String(index)
            yearsArry.append(stringNumber)
        }
        return yearsArry
    }
    
    var playersAge : [String] {
        var agesArray = [String]()
        for index in 8...70 {
            let stringNumber = String(index)
            agesArray.append(stringNumber)
        }
        return agesArray
    }
    let spinnerArray = ["cycling-1", "cycling-2", "cycling-3", "cycling-4", "cycling-5", "cycling-6", "cycling-7", "cycling-8", "cycling-9", "cycling-10", "cycling-11", "cycling-12", "cycling-13",  "cycling-14", "cycling-15", "cycling-16", "cycling-17", "cycling-18", "cycling-19", "cycling-20", "cycling-21", "cycling-22", "cycling-23", "cycling-24", "cycling-25", "cycling-26", "cycling-27", "cycling-28", "cycling-29", "cycling-30", "cycling-31", "cycling-32", "cycling-33", "cycling-34", "cycling-35", "cycling-36", "cycling-37"
    ]
}
