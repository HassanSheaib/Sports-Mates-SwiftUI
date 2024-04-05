//
//  GamesListViewModel.swift
//  SportMates
//
//  Created by HHS on 30/09/2022.
//


import Foundation
import CoreLocation

class GamesListViewModel: ObservableObject {
    
    private var firestoreManager: FirestoreManager
    var userLocation : LocationModal
    @Published var games: [GameViewModel] = []
    
    @Published var pressedGame = GameViewModel(game: Game(creatorUUID: "", creatorName: "", creatorGender: "", creatorAge: "", sportName: "", date: Date(), time: "", duration: "", gamePurpose: "", playersLevels: "", minNumberOfplayers: 0, idealNumberOfPlayers: 0, minPlayersAge: 0, maxPlayersAge: 0, currentNumberOfPlayers: 0, location: LocationModal(cityName: "", gouvernate: "", country: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0)), genderMatters: false, playersGender: "", joinedPlayersUUID: [""], gameChatroomID: ""), id: "")
    
    init() {
        firestoreManager = FirestoreManager()
        userLocation = LocationModal(cityName: "", gouvernate: "", country: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    }
    
    func getNearbyGames(userLocation: CLLocation, rangeDistance: Double, handler: @escaping(_ games: [GameViewModel])  -> ()) {
        
        LocationManager.shared.getReverseGeoCodedLocation(location: userLocation) { location, placemark, error in
            
            self.userLocation = LocationModal(cityName: placemark?.name ?? "", gouvernate: placemark?.administrativeArea ?? "", country: placemark?.country ?? "", coordinate: CLLocationCoordinate2D(latitude: placemark?.location?.coordinate.latitude ?? 0.0, longitude: placemark?.location?.coordinate.longitude ?? 0.0))
            
            self.firestoreManager.getAllNearbyGames(userLocation: self.userLocation, distanceRange: rangeDistance) { games in
                self.games = games
                handler(self.games)
            }

        }
    }
    
    func getUserJoinedGames(userID: String, gamesIDs: [String], handler: @escaping() -> ())   {
        firestoreManager.getMyGames(userID: userID, joinedGamesIDs: gamesIDs) { games in
            self.games = games
            handler()
        }
    }

}

struct GameViewModel: Identifiable{
    let game : Game
    
    var id: String
    
    var creatorUUID: String{
        game.creatorUUID
    }
    var creatorName: String{
        game.creatorName
    }
    var creatorGender: String{
        game.creatorGender
    }
    var creatorAge: String{
        game.creatorAge
    }
    
    var sportName: String {
        game.sportName
    }
    
    var date: Date {
        game.date
    }
    
    var time: String {
        game.time
    }
    
    var duration: String {
        game.duration
    }
    var gamePurpose: String {
        game.gamePurpose
    }
    
    var playersLevels: String {
        game.playersLevels
    }
    var minNumberOfPlayers : Int{
        game.minNumberOfplayers
    }
    var idealNumberOfPlayers : Int{
        game.idealNumberOfPlayers
    }
    var currentNumberOfPlayers : Int{
        game.currentNumberOfPlayers
    }
    var minPlayersAge: Int {
        game.minPlayersAge
    }
    var maxPlayersAge: Int {
        game.maxPlayersAge
    }
    var locationCityName: String {
        game.location.cityName
    }
    var locationGouvernateName: String {
        game.location.gouvernate
    }
    var locationCountryName: String {
        game.location.country
    }
    var locationLatitude: Double {
        game.location.coordinate.latitude
    }
    var locationLongitude: Double {
        game.location.coordinate.longitude
    }
    var genderMatters : Bool{
        game.genderMatters
    }
    var playersGender: String{
        game.playersGender
    }
    var joinedPlayerUUID: [String]{
        game.joinedPlayersUUID
    }
    var gameChatroomID: String{
        game.gameChatroomID
    }
    

}

