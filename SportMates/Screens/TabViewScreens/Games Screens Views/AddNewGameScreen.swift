//
//  AddNewGameScreen.swift
//  SportMates
//
//  Created by HHS on 23/09/2022.
//

import SwiftUI
import MapKit

struct AddNewGameScreen: View {
    
    
    //MARK: Proprities
    
    let constants = Constants()
    @StateObject private var addGameVM = AddAndDeleteGamesViewModel()
    @StateObject private var userVM = UserViewModel()
    @StateObject private var userGameListVM = GamesListViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    @State var location = [MapPinLocation]()
    @State var error = false
    
    
    
    // View Proprities
    @State private var pulsate: Bool = false
    @State var showMapView = false
    @State var showSpinner = false
    @State var showAlert = false
    
    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
            .speed(1)
            .delay(0.25)
    }
    //MARK: FUNCTIONS
    func checkUserGames() -> Bool{
        var inGame = false
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        let gameDateString = formatter.string(from: addGameVM.gameDate)
        let gameDateStringFormatted = gameDateString.replacingOccurrences(of: " ", with: "")

        for id in userVM.user.joinedGamesUUID{
            print(gameDateStringFormatted)
            if id.contains(gameDateStringFormatted){
                inGame = true
                break
            }
        }
        return inGame
    }
    
    func checkEnterdedValuesAndSaveGame()    {
        self.showSpinner.toggle()
        if self.checkUserGames() {
                addGameVM.createGameAlert = .alreadyCreatedGameForThisday
        }else if addGameVM.location.country == "" || addGameVM.location.gouvernate == "" || addGameVM.location.cityName == ""{
                addGameVM.createGameAlert = .locationEmpty
                self.error.toggle()
            }else{
                addGameVM.createGameAlert = .noError
                self.showSpinner.toggle()
                addGameVM.createGame(user: userVM.user) {
                    print("DOCUMENT SAVED IN THE BETTER WAY")
                }
        }

    }

    //MARK: VIEW
    var body: some View {
        VStack{
            
            if showSpinner {
                Spinner()
            }else{
                VStack{
                    HeaderView(title: error ? "Location Not Set" : "Create Game", note: error ? "Game Cannot be created without the game location" :"All Fileds Are required. Enjoy The Game!!", color: error ? .red : .white, image: addGameVM.sportName)
                    Form{
                        
                        Section(header:Text("Game type and Duration")){
                            HStack{
                                Picker("Game:", selection: $addGameVM.sportName) {
                                    ForEach(constants.gamesArray, id: \.self) {
                                        Text($0)
                                            
                                    }
                                }
                               
                            }
                            HStack{
                                Picker("Duration:", selection: $addGameVM.duration) {
                                    ForEach(constants.durations, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                        }
                        
                        Section(header:Text("How many player you got")){
                            HStack{
                                Stepper("I Got \(addGameVM.initialNumberOfPlayers)", value: $addGameVM.initialNumberOfPlayers, in: 1...22, step: 1)
                                    
                            }
                        }
                        
                        Section(header: Text("Players ages"))  {
                            HStack{
                                Picker("Min age:", selection: $addGameVM.minPlayersAge) {
                                    ForEach(constants.playersAge, id: \.self) {
                                        Text($0)
                                    }
                                }
                                Picker("Max age:", selection: $addGameVM.maxPlayersAge) {
                                    ForEach(constants.playersAge, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                            
                        }
                        Section(header: Text("Gender Info"))  {
                            HStack{
                                Toggle(isOn: $addGameVM.genderMatters) {
                                    Text("Gender Matter?")
                                }
                                .tint(Color.accentColor)
                            }
                        }
                        Section(header: Text("Number of Players"))  {
                            HStack{
                                Picker("Min:", selection: $addGameVM.minNumberOfplayers) {
                                    ForEach(constants.numberOfPlayers, id: \.self) {
                                        Text($0)
                                    }
                                }
                                Picker("Ideal:", selection: $addGameVM.idealNumberOfPlayers) {
                                    ForEach(constants.numberOfPlayers, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                            
                        }
                        Section(header: Text("Game Time & Date"))  {
                            
                            DatePicker("Hour:", selection: $addGameVM.time, displayedComponents: .hourAndMinute)
                            
                            DatePicker("Day:", selection: $addGameVM.gameDate, in: Date()...Date.now.addingTimeInterval(259200), displayedComponents: .date)
                            
                            
                        }
                        Section(header: Text("Game Purpose & Players Level"))  {
                            Picker("Playing For:", selection: $addGameVM.gamePurpose) {
                                ForEach(constants.purposes, id: \.self) { value in
                                    Text(value)
                                        .tag(value)
                                }
                            }
                            Picker("Players Level:", selection: $addGameVM.playersLevels) {
                                ForEach(constants.playersLevel, id: \.self) { value in
                                    Text(value)
                                        .tag(value)
                                }
                            }
                            
                        }
                        Section(header: Text("Game Location"))  {
                            HStack{
                                Text("Set Location On Map").foregroundColor(error ? .red : .white )
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(error ? Color.red : Color.white)
                                    
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.title3)
                                        .foregroundColor(.accentColor)
                                }
                                
                                .frame(width: 36, height: 36, alignment: .center)
                                .gesture(
                                    TapGesture().onEnded {
                                        print("Hello")
                                        self.showMapView.toggle()
                                    }
                                )
                                
                            }
                        }
                        
                       
                        
                    }
                    if !location.isEmpty{
                            LocationRowView(cityName: addGameVM.location.cityName, gouvernate: addGameVM.location.gouvernate, country: addGameVM.location.country)
                    }
                    Button()  {
                        self.checkEnterdedValuesAndSaveGame()
                    } label: {
                        Text("Create Game")
                            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        
                    }
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    
                    
                }
            }
        }
        .task {
             userVM.getUserDataByID {}
        }
        .alert(using: $addGameVM.createGameAlert) { alert in
            switch alert {
            case .noError:
                return Alert(title: Text("Game Saved"), message: Text("Game created now wait for other players to join"),  dismissButton: .default(Text("Let's GO")) {
                    self.presentationMode.wrappedValue.dismiss()
                })
            case .alreadyCreatedGameForThisday:
                return Alert(title: Text("Already Created Game"), message: Text("You already have a game scheduled for \(addGameVM.gameDate, format: Date.FormatStyle().month().day().weekday(.wide)) you can create game for a different date!!"),  dismissButton: .default(Text("Ok")) {
                    self.showSpinner.toggle()

                })
            case .locationEmpty:
                return Alert(title: Text("Missing Location!"), message: Text("Cannot Create Game without setting a location!!"),  dismissButton: .default(Text("OK")) {
                    self.showSpinner.toggle()
                    self.error.toggle()
                })




                
        }
    }
        .sheet(isPresented: $showMapView, onDismiss: {
            print("map view dismissed")
            if !location.isEmpty {
                let gamelocation = CLLocation(latitude: location[0].latitude, longitude: location[0].longitude)
                
                LocationManager.shared.getReverseGeoCodedLocation(location: gamelocation) { location, placemark, error in
                    
                    addGameVM.location = LocationModal(cityName: placemark?.name ?? "", gouvernate: placemark?.administrativeArea ?? "", country: placemark?.country ?? "", coordinate: CLLocationCoordinate2D(latitude: placemark?.location?.coordinate.latitude ?? 0.0, longitude: placemark?.location?.coordinate.longitude ?? 0.0))
                    
                    print(addGameVM.location)
                    
                }
            }
        }) {
            InsetMapView(iconImage: addGameVM.sportName, location: $location, showMapView: $showMapView)
        }
        .overlay(
            HStack (spacing: 20){
                Spacer()
                
                VStack {
                    Button(action: {
                        // ACTION
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .opacity(self.pulsate ? 1 : 0.6)
                            .scaleEffect(self.pulsate ? 1.2 : 0.8, anchor: .center)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
                    })
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

struct AddNewGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddNewGameScreen()
    }
}
