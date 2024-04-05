//
//  GameModel.swift
//  SportMates
//
//  Created by HHS on 22/09/2022.
//

import Foundation


struct Game {
    var creatorUUID: String
    var creatorName :String
    var creatorGender : String
    var creatorAge: String
    var sportName: String
    var date: Date
    var time: String
    var duration: String
    var gamePurpose: String
    var playersLevels: String
    var minNumberOfplayers: Int
    var idealNumberOfPlayers : Int
    var minPlayersAge : Int
    var maxPlayersAge : Int
    var currentNumberOfPlayers: Int
    var location: LocationModal
    var genderMatters: Bool
    var playersGender: String
    var joinedPlayersUUID : [String]
    var gameChatroomID : String
}


