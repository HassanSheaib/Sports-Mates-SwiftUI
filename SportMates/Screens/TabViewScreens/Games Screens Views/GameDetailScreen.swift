//
//  GameDetailScreen.swift
//  SportMates
//
//  Created by HHS on 23/09/2022.
//

import SwiftUI
import CoreLocation

struct GameDetailScreen: View {
    
    @StateObject private var firestoreManger = FirestoreManager()
    @StateObject private var joinGameVM = JoinGameModelView()
    @StateObject private var userVM = UserViewModel()
    @StateObject var gamesListVM = GamesListViewModel()
    
    
    @State var gameID: String
    
    
    
    @State private var showHeadline: Bool = false
    @State private var pulsate: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
            .speed(1)
            .delay(0.25)
    }
    
    var body: some View {
        
        VStack{
            if joinGameVM.game.sportName == "" || userVM.user.id == ""{
                Spinner()
            }else{
                VStack{
                    ScrollView(.vertical, showsIndicators: false){
                        
                        Image(joinGameVM.game.sportName)
                            .resizable()
                            .frame(height: UIScreen.main.bounds.height * 0.3)
                        Text("\(joinGameVM.game.sportName) Game Info")
                            .fontWeight(.bold)
                            .font(.system(.title, design: .serif))
                            .foregroundColor(Color.accentColor)
                            .padding(8)
                        
                        GameInfoCardView(game: joinGameVM.game)
                            .frame(maxWidth: 640)
                        
                        // Map
                        Text("On Map Location")
                            .fontWeight(.bold)
                            .font(.system(.title, design: .serif))
                            .foregroundColor(Color.accentColor)
                            .padding(8)
                        
                        Group{
                            LocationRowView(cityName: joinGameVM.game.locationCityName, gouvernate: joinGameVM.game.locationGouvernateName, country: joinGameVM.game.locationCountryName)
                            
                            
                            DetailScreenMapView(game: joinGameVM.game, locations: [MapPinLocation(id: UUID(), name: joinGameVM.game.sportName, description: "", latitude: joinGameVM.game.locationLatitude, longitude: joinGameVM.game.locationLongitude)])
                                .frame(height: 400)
                            Text("Press on the game location to open in Google Maps")
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                    }
                    if !joinGameVM.game.joinedPlayerUUID.contains(userVM.user.id){
                        Button {
                            self.joinGameVM.joinGame(user: userVM.user)
                        } label: {
                            Text("Join Game")
                                .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                            
                        }
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
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
                                    .foregroundColor(Color.white)
                                    .shadow(radius: 4)
                                    .opacity(self.pulsate ? 1 : 0.6)
                                    .scaleEffect(self.pulsate ? 1.2 : 0.8, anchor: .center)
                                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsate)
                                    .onAppear() {
                                        self.pulsate.toggle()
                                    }
                            })
                            .padding(.trailing, 20)
                            .padding(.top, 24)
                            Spacer()
                        }
                        
                    }.padding()
                )
            }
        }
        .task {
            joinGameVM.getPressedGame(gameID: self.gameID)
            userVM.getUserDataByID {}
            
            
        }
        .alert(using: $joinGameVM.errorAlert) { alert in
            switch alert {
            case .noErrors:
                return Alert(title: Text("Game Joined"), message: Text("Please make sure to be there on time!!!"),  dismissButton: .default(Text("Let's GO")) {
                    self.presentationMode.wrappedValue.dismiss()
                })
            case .alreadyInGame:
                return Alert(
                    title: Text("You Already joined this Game"),
                    message: Text("")
                )
            case .genderDoesNotMatch:
                return Alert(title: Text("Can't Join Game"), message: Text("Your gender does not match the game requirement"))
            case .notInAgeRange:
                return Alert(title: Text("Can't Join Game"), message: Text("Your age does not match the game age range"))
            case .gameIsFull:
                return Alert(title: Text("Can't Join Game"), message: Text("The Game is Full"))
            case .alreadyInGameOnTheSameDate:
                return Alert(title: Text("Can't Join Game"), message: Text("You are already in A game on \(joinGameVM.game.date, format: Date.FormatStyle().month().day().weekday(.wide)) "))
                
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}


struct GameDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailScreen(gameID: "sdhsjhdjs")
        
    }
}
