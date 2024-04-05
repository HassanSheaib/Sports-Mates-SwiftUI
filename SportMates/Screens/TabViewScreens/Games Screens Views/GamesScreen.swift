//
//  GamesScreen.swift
//  SportMates
//
//  Created by HHS on 22/09/2022.
//

import SwiftUI
import CoreLocation
import Firebase

struct GamesScreen: View {
    
    
    // MARK: Proprities
    @ObservedObject private var firestoreManger = FirestoreManager()
    @StateObject var gamesListVM = GamesListViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var addAndDeleteGames = AddAndDeleteGamesViewModel()
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    
    
    // VIEW PROPRITIES
    
    let constants = Constants()
    @State var filteredArray = [GameViewModel]()
    @State var gameType = "All"
    @State var gameDate = Date()
    
    @State var distance = 10.0
    @State var distanceString = "10"
    
    @State var showSpinner = false
    @State var showAddGameScreen = false
    @State var locationEnabled = true
    
    @State private var showModal = false
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    //ANIMATION PROPERTIES
    @State private var pulsate: Bool = false
    
    //MARK: FUNCTIONS
    
    func getCurrentLocation(handler: @escaping(_ userLocation: CLLocation)  -> ()){
        
        LocationManager.shared.getLocation { location, error in
            if let error = error {
                if error.localizedDescription ==  LocationManager.LocationErrors.denied.rawValue {
                    locationEnabled = false
                }
                print("error in getting Location \(error.localizedDescription)")
                return
            }
            guard let location = location else {
                return
            }
            self.userVM.userLocation = location
            locationEnabled = true
            handler(location)
        }
    }
    
    func settingsOpener(){
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    func filterGames(wantedDate: Date, games: [GameViewModel]){
        
        self.filteredArray.removeAll()
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        let date = formatter.string(from: wantedDate)
        
        
        if gameType == "All" {
            for game in games {
                let currentGameDate = formatter.string(from: game.date)
                if currentGameDate == date {
                    self.filteredArray.append(game)
                }
            }
        }else{
            for game in games {
                let currentGameDate = formatter.string(from: game.date)
                if currentGameDate == date && game.sportName == gameType {
                    self.filteredArray.append(game)
                }
            }
        }
        
    }
    
    
    
    //MARK: View
    var body: some View {
        ZStack{
            Color.black
            VStack{
                // NAV Bar
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(Date(), format: Date.FormatStyle().month().day().weekday(.wide))
                                .font(.footnote)
                                .foregroundColor(Color(.gray))
                        }
                        Text("Games")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        
                    }
                    Spacer()
                    HStack{
                        Button {
                            self.showAddGameScreen.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.white)
                                .font(.title)
                                .shadow(radius: 4)
                                .opacity(self.pulsate ? 1 : 0.6)
                                .scaleEffect(self.pulsate ? 1.2 : 0.8, anchor: .center)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
                        }
                        .onAppear(perform: {
                            self.pulsate = true
                        })
                    }
                }
                .padding()
                
                if showSpinner{
                    Spacer()
                    Spinner()
                    Spacer()
                    
                }else if  !locationEnabled{
                    Spacer()
                    VStack{
                        Image(systemName: "location.slash.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding()
                        Text("The App need access to your current location!!")
                        Button {
                            self.settingsOpener()
                        } label: {
                            Text("Go to settings?")
                                .italic()
                        }
                        
                        
                    }
                    Spacer()
                    
                }else{
                    HStack{
                        Text("Games:")
                        Picker("", selection: $gameType) {
                            ForEach(constants.gamesForFilter, id: \.self) {  value in
                                Text(value)
                            }
                        }
                        .accentColor(.white)
                        Spacer()
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .padding(.horizontal)
                    .background(Color("ColorBlackLight"))
                    .cornerRadius(12)
                    
                    HStack{
                        Text("In range:")
                            .foregroundColor(.white)
                        Picker("", selection: $distanceString) {
                            ForEach(constants.distanceRange, id: \.self) { value in
                                Text(value)
                                
                                
                            }
                        }
                        .accentColor(.white)
                        
                        Text("KM, On:")
                            .foregroundColor(.white)
                        
                        DatePicker("", selection: $gameDate, in: Date()...Date.now.addingTimeInterval(259200), displayedComponents: .date)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .padding(.horizontal)
                    .background(Color("ColorBlackLight"))
                    .cornerRadius(12)
                    
                    List {
                        if gamesListVM.games.isEmpty{
                            Text("No Available Games")
                        }else if !filteredArray.isEmpty{
                            ForEach(filteredArray) { gameViewModal in
                                GameView(game: gameViewModal)
                                    .onTapGesture {
                                        self.gamesListVM.pressedGame = gameViewModal
                                        self.hapticImpact.impactOccurred()
                                        self.showModal = true
                                    }
                            }
                        }else {
                            Text("No Available \(gameType == "All" ? "" : gameType) games")
                        }
                    }
                    
                }
            }
        }
        .task{
            if userVM.userLocation == nil{
                self.getCurrentLocation { userLocation in
                    gamesListVM.getNearbyGames(userLocation: userLocation, rangeDistance: distance) { games in
                        
                        self.filterGames(wantedDate: gameDate, games: games)
                    }
                }
            }else{
                gamesListVM.getNearbyGames(userLocation: userVM.userLocation!, rangeDistance: distance) { games in
                    self.filterGames(wantedDate: gameDate, games: games)
                }
            }
        }
        .sheet(isPresented: self.$showAddGameScreen) {
            AddNewGameScreen()
        }
        .sheet(isPresented: self.$showModal) {
            GameDetailScreen(gameID: gamesListVM.pressedGame.id)
        }
        .onChange(of: gameType) { newValue in
            self.filterGames(wantedDate: gameDate, games: gamesListVM.games)
        }
        .onChange(of: gameDate) { newValue in
            self.gameDate = newValue
            self.filterGames(wantedDate: gameDate, games: gamesListVM.games)
        }
        .onChange(of: distanceString) { newValue in
            if let dist = Double(newValue.prefix(3)) {
                self.distance = dist
                gamesListVM.getNearbyGames(userLocation: userVM.userLocation!, rangeDistance: distance) { games in
                    self.filterGames(wantedDate: gameDate, games: games)
                }
            } else {
                if let distanceRange = Double(newValue.prefix(2)) {
                    self.distance = distanceRange
                    gamesListVM.getNearbyGames(userLocation: userVM.userLocation!, rangeDistance: distance) { games in
                        self.filterGames(wantedDate: gameDate, games: games)
                    }
                    
                }
            }
            
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                self.getCurrentLocation { userLocation in
                    gamesListVM.getNearbyGames(userLocation: userLocation, rangeDistance: distance) { games in
                        self.filterGames(wantedDate: gameDate, games: games)
                    }
                }
                print("Active")
            }
        }
    }
}


struct GamesScreen_Previews: PreviewProvider {
    static var previews: some View {
        GamesScreen()
    }
}
