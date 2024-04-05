//
//  JoinGameViewModel.swift
//  SportMates
//
//  Created by HHS on 05/10/2022.
//

import Foundation
import CoreLocation

class JoinGameModelView: ObservableObject {
    
    
    
    private var firestoreManager: FirestoreManager
    
    enum ErrorAlert {
        case noErrors
        case alreadyInGame
        case genderDoesNotMatch
        case notInAgeRange
        case gameIsFull
        case alreadyInGameOnTheSameDate
    }
    
    @Published var errorAlert: ErrorAlert?
    @Published var game = GameViewModel(game: Game(creatorUUID: "", creatorName: "", creatorGender: "", creatorAge: "", sportName: "", date: Date(), time: "", duration: "", gamePurpose: "", playersLevels: "", minNumberOfplayers: 0, idealNumberOfPlayers: 0, minPlayersAge: 0, maxPlayersAge: 0, currentNumberOfPlayers: 0, location: LocationModal(cityName: "", gouvernate: "", country: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0)), genderMatters: false, playersGender: "", joinedPlayersUUID: [""], gameChatroomID: ""), id: "")
    
    init() {
        firestoreManager = FirestoreManager()
    }
    
    func getPressedGame(gameID: String){
        firestoreManager.getPressedGame(gameID: gameID) { game in
            self.game = game
        }
    }
    
    func joinGame(user: UserModel){
        
        if (game.joinedPlayerUUID.contains(user.id)){
            self.errorAlert = .alreadyInGame
        }else if(game.genderMatters && (game.playersGender == user.gender) == false){
            self.errorAlert = .genderDoesNotMatch
        }else if(user.age > game.maxPlayersAge || user.age < game.minPlayersAge){
            self.errorAlert = .notInAgeRange
        }else if(game.idealNumberOfPlayers <= (game.joinedPlayerUUID.count)){
            self.errorAlert = .gameIsFull
        }else if self.checkUserJoinedGames(joinedGamesIDS: user.joinedGamesUUID){
            self.errorAlert = .alreadyInGameOnTheSameDate
        }else{
            self.errorAlert = .noErrors
                self.firestoreManager.updateGameAndUserDataWhenUserJoins(gameID: self.game.id, userID: user.id, gameChatroomID: self.game.gameChatroomID)
        }
    }
    
    func checkUserJoinedGames (joinedGamesIDS: [String])->Bool{
        var tempBool = false
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        
        let gameDateString = formatter.string(from: game.date)
        let gameDateStringFormatted = gameDateString.replacingOccurrences(of: " ", with: "")

        for id in joinedGamesIDS{
            if id.contains(gameDateStringFormatted){
                tempBool = true
                break
            }
        }
        
        return tempBool
    }
}
