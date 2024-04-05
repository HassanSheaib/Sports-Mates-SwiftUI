//
//  AddGameViewModel.swift
//  SportMates
//
//  Created by HHS on 30/09/2022.
//

import Foundation
import MapKit
import Firebase

class AddAndDeleteGamesViewModel: ObservableObject {
    
    private var firestoreManager: FirestoreManager
    
    enum DeleteAndLeaveGame {
        case deleteGame
        case leaveGame
        case signOut
    }
    enum CreateGameErrors {
        case alreadyCreatedGameForThisday
        case locationEmpty
        case noError
    }
    @Published var createGameAlert: CreateGameErrors?
    @Published var deleteAlert: DeleteAndLeaveGame?
    
    @Published var game = GameViewModel(game: Game(creatorUUID: "", creatorName: "", creatorGender: "", creatorAge: "", sportName: "", date: Date(), time: "", duration: "", gamePurpose: "", playersLevels: "", minNumberOfplayers: 0, idealNumberOfPlayers: 0, minPlayersAge: 0, maxPlayersAge: 0, currentNumberOfPlayers: 0, location: LocationModal(cityName: "", gouvernate: "", country: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0)), genderMatters: false, playersGender: "", joinedPlayersUUID: [""], gameChatroomID: ""), id: "")
    
    @Published var saved: Bool = false
    @Published var message: String = ""
    
    
    @Published var sportName = "Football"
    @Published var initialNumberOfPlayers = 1
    @Published var duration = "1hr"
    @Published var gamePurpose = "For Fun"
    @Published var playersLevels =  "Beginners"
    @Published var gameDate = Date()
    @Published var time = Date()
    @Published var minNumberOfplayers = "2"
    @Published var idealNumberOfPlayers = "10"
    @Published var minPlayersAge = "8"
    @Published var maxPlayersAge = "60"
    @Published var genderMatters = true
    @Published var location = LocationModal(cityName: "", gouvernate: "", country: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    


    
    init() {
        firestoreManager = FirestoreManager()
    }

    
    
    func createGame(user: UserModel, handler: @escaping() -> ()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        let gameDateString = formatter.string(from: gameDate)
        let gameID = user.email + self.sportName + gameDateString + user.provider
        let formattedGameID = gameID.replacingOccurrences(of: " ", with: "")
        let chatRoomID = user.email + gameDateString + user.provider
        let formattedChatRoomID = chatRoomID.replacingOccurrences(of: " ", with: "")


        let time =  time.formatted(date: .omitted, time: .shortened)
        let minAge = Int(minPlayersAge) ?? 8
        let maxAge = Int(maxPlayersAge) ?? 60
        let idealNbrOfplayers = Int(idealNumberOfPlayers) ?? 4
        let minNbrOfplayers = Int(minNumberOfplayers) ?? 2

        let chatRoom = ChatRoomModel(id: formattedChatRoomID, gameName: self.sportName, gameDate: self.gameDate, creatorID: user.id, messages: [Message(id: "", userName: user.name, message: "Welcome in The chatroom for the \(sportName.uppercased()) game on \(gameDateString), make sure to be at the sport center on time, stay safe and dont forget to be nice to each others", userID: "undefined", timeStamp: Date())])
        

        let game = Game(creatorUUID: user.id, creatorName: user.name, creatorGender: user.gender, creatorAge: String(user.age), sportName: sportName, date: gameDate, time: time, duration: duration, gamePurpose: gamePurpose, playersLevels: playersLevels, minNumberOfplayers: minNbrOfplayers, idealNumberOfPlayers: idealNbrOfplayers, minPlayersAge: minAge, maxPlayersAge: maxAge, currentNumberOfPlayers: initialNumberOfPlayers, location: location, genderMatters: genderMatters, playersGender: genderMatters ? user.gender : "Does Not Matter" , joinedPlayersUUID: [user.id], gameChatroomID: formattedChatRoomID)
        
        firestoreManager.saveGameData(userID: user.id, gameID: formattedGameID, chatroom: chatRoom, game: game)
        handler()
    }
    
    
    func deleteGame(handler: @escaping() -> ()){
        self.firestoreManager.deleteGame(gameID: self.game.id, gameChatroomID: self.game.gameChatroomID) {
            handler()
        }
    }

    func leaveGame(user: UserModel,handler: @escaping() -> ()){
        firestoreManager.leaveGame(gameID: self.game.id, userID: user.id, gameChatroomId: game.gameChatroomID) {
            handler()
        }
    }
}
