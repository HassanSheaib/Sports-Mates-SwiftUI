//
//  FirestoreManger.swift
//  SportMates
//
//  Created by HHS on 27/09/2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import CoreLocation

class FirestoreManager: ObservableObject {
    
    private var db: Firestore
    
    
    
    init() {
        db = Firestore.firestore()
    }
    
    //MARK: PRIVATE FUNCTIONS

    private func convertUserModelToDictionary(user: UserModel) -> [String : Any] {
        
        let userData = [
            "id" : user.id,
            "name" : user.name,
            "email": user.email,
            "loginProvider": user.provider,
            "yearOfBirth": user.yearOfBirth,
            "gender": user.gender,
            "joinedGamesUUID" : user.joinedGamesUUID,
            "gamesChatroomsUUIDs" : user.gamesChatroomsUUIDs
        ] as [String : Any]
        
        return userData
    }
    private func getUserModel(document: DocumentSnapshot ) -> UserModel?{
        
     if let id = document.get("id") as? String,
        let name  = document.get("name") as? String,
        let gender  = document.get("gender") as? String,
        let yearOfbirth = document.get("yearOfBirth") as? String,
        let email  = document.get("email") as? String,
        let loginProvider  = document.get("loginProvider") as? String,
        let joinedGamesUUID = document.get("joinedGamesUUID") as? [String],
        let gamesChatroomsUUIDs = document.get("gamesChatroomsUUIDs") as? [String]{
        
         let userInfo = UserModel(id: id, email: email, provider: loginProvider, name: name, yearOfBirth: yearOfbirth, gender: gender, joinedGamesUUID: joinedGamesUUID, gamesChatroomsUUIDs: gamesChatroomsUUIDs)
        
            return userInfo
        }else{
            return nil
        }
    }
    private func convertGameModelToDictionary(game: Game) -> [String : Any]{
        
        let gameData = [
            "creatorUUID" : game.creatorUUID,
            "creatorName": game.creatorName,
            "creatorGender": game.creatorGender,
            "creatorAge": game.creatorAge,
            "sportName" : game.sportName,
            "time": game.time,
            "date": game.date,
            "duration" : game.duration,
            "gamePurpose" : game.gamePurpose,
            "playersLevel" : game.playersLevels,
            "playersGender": game.playersGender,
            "minNumberOfPlayers" : game.minNumberOfplayers,
            "idealNumberOfPlayers" : game.idealNumberOfPlayers,
            "currentNumberOfPlayers" : game.currentNumberOfPlayers,
            "minPlayersAge" : game.minPlayersAge,
            "maxPlayersAge" : game.maxPlayersAge,
            "city" : game.location.cityName,
            "gouvernat" : game.location.gouvernate,
            "country" : game.location.country,
            "lat" : game.location.coordinate.latitude,
            "long" : game.location.coordinate.longitude,
            "joinedPlayersUUID" : game.joinedPlayersUUID,
            "genderMatters" : game.genderMatters,
            "gameChatroomID" : game.gameChatroomID
            
            
        ] as [String : Any]
        
        return gameData
    }
    private func getGameViewModal(document: DocumentSnapshot ) -> GameViewModel?{
        
        if  let creatorUUID = document.get("creatorUUID") as? String,
            let creatorName = document.get("creatorName") as? String,
            let creatorGender = document.get("creatorGender") as? String,
            let creatorAge = document.get("creatorAge") as? String,
            let sportName  = document.get("sportName") as? String,
            let time  = document.get("time") as? String,
            let date  = document.get("date") as? Timestamp,
            let duration  = document.get("duration") as? String,
            let gamePurpose = document.get("gamePurpose") as? String,
            let playersLevel  = document.get("playersLevel") as? String,
            let playersGender  = document.get("playersGender") as? String,
            let minNumberOfPlayers  = document.get("minNumberOfPlayers") as? Int,
            let idealNumberOfPlayers  = document.get("idealNumberOfPlayers") as? Int,
            let currentNumberOfPlayers = document.get("currentNumberOfPlayers") as? Int,
            let minPlayersAge  = document.get("minPlayersAge") as? Int,
            let maxPlayersAge  = document.get("maxPlayersAge") as? Int,
            let country  = document.get("country") as? String,
            let city  = document.get("city") as? String,
            let gouvernat  = document.get("gouvernat") as? String,
            let lat  = document.get("lat") as? Double,
            let long  = document.get("long") as? Double,
            let joinedPlayersUID  = document.get("joinedPlayersUUID") as? [String],
            let genderMatters  = document.get("genderMatters") as? Bool,
            let gameChatroomID =  document.get("gameChatroomID") as? String{
            
            let id = document.documentID
            let game = GameViewModel(game: Game(creatorUUID: creatorUUID, creatorName: creatorName, creatorGender: creatorGender, creatorAge: creatorAge, sportName: sportName, date: date.dateValue(), time: time, duration: duration, gamePurpose: gamePurpose, playersLevels: playersLevel, minNumberOfplayers: minNumberOfPlayers, idealNumberOfPlayers: idealNumberOfPlayers, minPlayersAge: minPlayersAge, maxPlayersAge: maxPlayersAge, currentNumberOfPlayers: currentNumberOfPlayers, location: LocationModal(cityName: city, gouvernate: gouvernat, country: country, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)), genderMatters: genderMatters, playersGender: playersGender, joinedPlayersUUID: joinedPlayersUID, gameChatroomID: gameChatroomID), id: id)
            return game
        }else{
            return nil
        }
    }
    private func getGamesFromSnapshot(userLocation: LocationModal, distanceRange: Double, querySnapshot: QuerySnapshot?) -> [GameViewModel] {
        var gamesArray = [GameViewModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                if let game = self.getGameViewModal(document: document){
                    
                    let gameLocation = CLLocation(latitude: game.locationLatitude, longitude: game.locationLongitude)
                    
                    let mylocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                    let distance = mylocation.distance(from: gameLocation)/1000
                    
                    let order = Calendar.current.compare(Date(), to: game.date, toGranularity: .day)
                    
                    if order == .orderedDescending{
                        self.deleteGame(gameID: game.id, gameChatroomID: game.gameChatroomID) {}
                    }else if distance < distanceRange {
                        gamesArray.append(game)
                    }
                }
            }
            return gamesArray
        } else {
            print("No games in document")
            return gamesArray
        }
    }
    private func getChatRoomModel(document: DocumentSnapshot ) -> ChatRoomModel?{
        
        if  let id = document.get("id") as? String,
            let gameName = document.get("gameName") as? String,
            let gameDate = document["gameDate"] as? Timestamp,
            let creatorID  = document.get("creatorID") as? String,
            let messages  = document.get("messages") as? [[String : Any]]{
            
            var messagesModelArray = [Message]()
            for message in messages {
                
                
                if let singleMessage = message["message"] as? String,
                   let username = message["username"] as? String,
                   let userID = message["userID"] as? String,
                   let timeStamp = message["timeStamp"] as? Timestamp{
                    
                    let stringID = timeStamp.dateValue().formatted(date: .complete, time: .complete)
                    
                    
                    let message = Message(id: stringID, userName: username, message: singleMessage, userID: userID, timeStamp: timeStamp.dateValue())
                    messagesModelArray.append(message)
                }
            }
            
            let chatroom = ChatRoomModel(id: id, gameName: gameName, gameDate: gameDate.dateValue(), creatorID: creatorID, messages: messagesModelArray)
            return chatroom
        }else{
            return nil
        }
    }

    //MARK: USER RELATED METHODS
    
    //MARK: save user Data
    
    func saveUserDataWithSameUID(userInfo: UserModel, completion: @escaping (Result<UserModel?, Error>) -> Void) {
        do {
            let userData = convertUserModelToDictionary(user: userInfo)
            try db.collection("userInformation").document(userInfo.id).setData(userData)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: get user Data
    
    func getUserData(userUIID: String, handler: @escaping(_ userInfo: UserModel)  -> ()) {
        
        let docRef = db.collection("userInformation").document(userUIID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userInfo = self.getUserModel(document: document){
                    handler(userInfo)
                }
            } else {
                let  defaultUserInfo = UserModel(id: "", email: "", provider: "", name: "", yearOfBirth: "", gender: "", joinedGamesUUID: [], gamesChatroomsUUIDs: [])
                handler(defaultUserInfo)
                print("Document does not exist")
            }
        }
    }
    

    //MARK: GAME RELATED METHODS
    
    // MARK: SAVE GAME DATA
    
    func saveGameData(userID: String, gameID: String, chatroom : ChatRoomModel ,game: Game) {
        
        let chatroomData = self.convertChatroomDataToDictionary(chatroom: chatroom)
        do {
            let gameData = convertGameModelToDictionary(game: game)
            try db.collection("games").document(gameID).setData(gameData)
            try db.collection("chatrooms").document(game.gameChatroomID).setData(chatroomData)
            try db.collection("userInformation").document(userID).updateData([
                "joinedGamesUUID": FieldValue.arrayUnion([gameID]),
                "gamesChatroomsUUIDs": FieldValue.arrayUnion([game.gameChatroomID])
            ])
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: GET GAMES LIST
    
    func getAllNearbyGames(userLocation: LocationModal, distanceRange: Double, handler: @escaping (_ games: [GameViewModel]) -> ()) {
        db.collection("games").addSnapshotListener { (querySnapshot, error) in
            handler(self.getGamesFromSnapshot(userLocation: userLocation, distanceRange: distanceRange, querySnapshot: querySnapshot))
        }
    }
    
    //MARK: UPDATE GAME AFTER USER JOINS OR GAME CREATED
    
    func updateGameAndUserDataWhenUserJoins(gameID: String, userID : String, gameChatroomID : String ){
        
        db.collection("games").document(gameID).updateData([
            "joinedPlayersUUID": FieldValue.arrayUnion([userID]),
            "currentNumberOfPlayers": FieldValue.increment(Int64(1))

        ])
        db.collection("userInformation").document(userID).updateData([
            "joinedGamesUUID": FieldValue.arrayUnion([gameID]),
            "gamesChatroomsUUIDs": FieldValue.arrayUnion([gameChatroomID])
        ])
    }

    //MARK: GET GAME WITH SPECIFIC ID Functions
    
    func getPressedGame(gameID: String, handler: @escaping(_ game: GameViewModel)  -> ()){
        db.collection("games").document(gameID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let game = self.getGameViewModal(document: document){
                    handler(game)

                }
            }
        }
    }
    
    
    //MARK: MY GAME SCREEN FUNCTIONS
    
    func getMyGames(userID: String, joinedGamesIDs: [String], handler: @escaping (_ games: [GameViewModel]) -> ()) {
        guard !joinedGamesIDs.isEmpty else {
            // If there is nothing to do, always consider
            // calling the handler anyway, with an empty
            // array, so the caller isn't left hanging.
            return handler([])
        }
        // Set up a Dispatch Group to coordinate the multiple
        // async tasks. Instatiate outside of the loop.
        let group = DispatchGroup()
        
        var games: [GameViewModel] = []
        
        for id in joinedGamesIDs {
            // Enter the group on each iteration of async work
            // to be performed.
            group.enter()
            
            db.collection("games").document(id).getDocument { (document, error) in
                if let doc = document,
                   doc.exists,
                   let game = self.getGameViewModal(document: doc) {
                    games.append(game)
                } else if let error = error {
                    // Always print errors when in development.
                    print(error)
                }else{
                    self.db.collection("userInformation").document(userID).updateData([
                        "joinedGamesUUID": FieldValue.arrayRemove([id])
                    ])
                    print("Document Does Not Exist")
                }
                // No matter what happens inside the iteration,
                // whether there was a success in getting the
                // document or a failure, always leave the group.
                group.leave()
            }
        }
        
        // Once all of the calls to enter the group are equalled
        // by the calls to leave the group, this block is called,
        // which is the group's own completion handler. Here is
        // where you ultimately call the function's handler and
        // return the array.
        group.notify(queue: .main) {
            handler(games)
        }
        
    }
    
    //MARK: Delete Created games
    
    func deleteGame(gameID: String, gameChatroomID: String, handler: @escaping()-> ()){
        
        db.collection("games").document(gameID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                
            } else {
                print("Document successfully removed!")
                self.deleteChatroom(gameChatroomID: gameChatroomID) {
                    handler()
                }
            }
        }
    }
    
    func deleteChatroom(gameChatroomID: String, handler: @escaping()-> ()){
        self.db.collection("chatrooms").document(gameChatroomID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                
            } else {
                print("Document successfully removed!")
                handler()
                
            }
        }
    }
    
    func leaveGame(gameID: String, userID: String, gameChatroomId: String, handler: @escaping()-> ()){
        
        db.collection("userInformation").document(userID).updateData([
            "joinedGamesUUID": FieldValue.arrayRemove([gameID]),
            "gamesChatroomsUUIDs": FieldValue.arrayRemove([gameChatroomId])
        ])
        
        db.collection("games").document(gameID).updateData([
            "joinedPlayersUUID": FieldValue.arrayRemove([userID]),
            "currentNumberOfPlayers": FieldValue.increment(Int64(-1))

        ])
        handler()
    }
    

    
    //MARK: CREATE CHATROOM FOR EVERY GAME
    private func convertChatroomDataToDictionary(chatroom: ChatRoomModel) -> [String: Any]{
        let chatRoomData = [
            "id" : chatroom.id,
            "gameName" : chatroom.gameName,
            "gameDate" : chatroom.gameDate,
            "creatorID" : chatroom.creatorID,
            "messages" : [[
                "message" : chatroom.messages[0].message,
                "username" : chatroom.messages[0].userName,
                "userID"  : chatroom.messages[0].userID,
                "timeStamp" : chatroom.messages[0].timeStamp
            ]]
            
        ] as [String : Any]
        
        return chatRoomData
    }
    
    func getUserChatRooms(userID: String, chatroomsID: [String], handler: @escaping(_ chatrooms: [ChatRoomModel])  -> ()) {
        guard !chatroomsID.isEmpty else {
            return handler([])
        }
        let group = DispatchGroup()
        var chatrooms: [ChatRoomModel] = []
        for id in chatroomsID {
            group.enter()
            db.collection("chatrooms").document(id).getDocument { (document, error) in
                if let doc = document, doc.exists,
                   let chatroom = self.getChatRoomModel(document: doc) {
                    chatrooms.append(chatroom)
                } else if let error = error {
                    print(error)
                }else{
                    self.db.collection("userInformation").document(userID).updateData([
                        "gamesChatroomsUUIDs": FieldValue.arrayRemove([id])
                    ])
                    print("Document Does not exist")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            handler(chatrooms)
        }
    }
    
    
    func sendMessage(message: String, username: String, userID: String, gameChatroomID: String, handler: @escaping()  -> ()){
        
        var firestoreData: [String: Any] {
            return [
                "message": message,
                "username" : username,
                "userID": userID,
                "timeStamp": Date()
            ]
        }
        self.db.collection("chatrooms").document(gameChatroomID).updateData(["messages" :  FieldValue.arrayUnion([firestoreData])])
        handler()
    }
            
    func loadMessages(gameChatroomID: String, handler: @escaping(_ messages: [Message])  -> () ){
        
        db.collection("chatrooms").document(gameChatroomID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    handler([])
                    
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    handler([])
                    return
                }
                if let id = data["id"] as? String,
                   let gameName = data["gameName"] as? String,
                   let gameDate = data["gameDate"] as? Timestamp,
                   let creatorID  = data["creatorID"] as? String,
                   let messages  = data["messages"] as? [[String : Any]]{
                    
                    var messagesModelArray = [Message]()
                    for message in messages {
                        if let singleMessage = message["message"] as? String,
                           let userID = message["userID"] as? String,
                           let userName = message["username"] as? String,
                           let timeStamp = message["timeStamp"] as? Timestamp{
                            
                            let stringID = timeStamp.dateValue().formatted(date: .complete, time: .complete)
                            let message = Message(id: stringID, userName: userName, message: singleMessage, userID: userID, timeStamp: timeStamp.dateValue())
                            messagesModelArray.append(message)
                            
                        }
                    }
                    let chatroom = ChatRoomModel(id: id, gameName: gameName, gameDate: gameDate.dateValue(), creatorID: creatorID, messages: messagesModelArray)
                    handler(chatroom.messages)
                }
            }
    }
}

