//
//  GameInfoCardView.swift
//  SportMates
//
//  Created by HHS on 04/10/2022.
//

import SwiftUI
import CoreLocation

struct GameInfoCardView: View {

    @State var game:  GameViewModel
    @State var showGameCreatorInfo = false
    
    
    var gameDateString : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        let date = formatter.string(from: game.date)
        return date
    }
    var body: some View {
        VStack {
            HStack (alignment: .center, spacing: 4){
                VStack{
                    Divider()
                    HStack() {
                        Image("calender")
                            .resizable()
                            .modifier(IconModifier())
                        Text(gameDateString)
                        Spacer()
                        Divider()
                        Spacer()
                        Text("\(game.locationCityName)")
                        Image("location")
                            .resizable()
                            .modifier(IconModifier())



                    }
                    Divider()
                }
            }
            
            .font(.footnote)
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color("ColorBlackLight"))
            .cornerRadius(12)
            
            HStack (alignment: .center, spacing: 4){
                VStack{
                    Divider()
                    HStack() {
                        Image("clock")
                            .resizable()
                            .modifier(IconModifier())
                        Text(game.time)
                        Spacer()
                        Divider()
                        Spacer()
                        Text("\(game.playersLevels)")
                        Image("player")
                            .resizable()
                            .modifier(IconModifier())



                    }
                    Divider()
                }
            }
            .font(.footnote)
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color("ColorBlackLight"))
            .cornerRadius(12)
            
            HStack (alignment: .center, spacing: 4){
                VStack{
                    Divider()
                    HStack() {
                        Image("chrono")
                            .resizable()
                            .modifier(IconModifier())
                        Text(game.duration)
                        Spacer()
                        Divider()
                        Spacer()
                        Text("\(game.gamePurpose)")
                        Image("medal")
                            .resizable()
                            .modifier(IconModifier())



                    }
                    Divider()
                }
            }
            .font(.footnote)
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color("ColorBlackLight"))
            .cornerRadius(12)
            
            HStack (alignment: .center, spacing: 4){
                VStack{
                    Divider()
                    HStack() {
                        Image("gender")
                            .resizable()
                            .modifier(IconModifier())
                        Text(game.genderMatters ? game.playersGender : "Doesn't Matter")
                        Spacer()
                        Divider()
                        Spacer()
                        Text("Age \(game.minPlayersAge) -> \(game.maxPlayersAge)")
                        Image("age")
                            .resizable()
                            .modifier(IconModifier())



                    }
                    Divider()
                }
            }
            .font(.footnote)
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color("ColorBlackLight"))
            .cornerRadius(12)
            
            HStack (alignment: .center, spacing: 4){
                VStack{
                    Divider()
                    HStack() {
                        Image("threepersons")
                            .resizable()
                            .modifier(IconModifier())
                        Text(game.minNumberOfPlayers == game.idealNumberOfPlayers ?
                             " \(game.currentNumberOfPlayers) joined from \(game.idealNumberOfPlayers)," : "\(game.currentNumberOfPlayers) joined from \(game.idealNumberOfPlayers) OR \(game.minNumberOfPlayers),")
                        Text("Game by")
                        Button {
                            self.showGameCreatorInfo.toggle()
                        } label: {
                            Text(game.creatorName)
                                .italic()
                        }



                        Spacer()
                    }
                    Divider()
                }
            }
            .font(.footnote)
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(Color("ColorBlackLight"))
            .cornerRadius(12)
            
            if showGameCreatorInfo{
                UserInfoRowView(gender: game.creatorGender, age: game.creatorAge)
            }
        }
    }
}


struct GameInfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        GameInfoCardView(game: GameViewModel(game: Game(creatorUUID: "", creatorName: "", creatorGender: "", creatorAge: "", sportName: "Football", date: Date(), time: "8:00PM", duration: "1hr", gamePurpose: "For Fun", playersLevels: "Beginner", minNumberOfplayers: 9, idealNumberOfPlayers: 12, minPlayersAge: 19, maxPlayersAge: 60, currentNumberOfPlayers: 1, location: LocationModal(cityName: "AN Nabatieh", gouvernate: "An Nabatieh", country: "Lebanon", coordinate: CLLocationCoordinate2D(latitude: 33.08988786767, longitude: 34.0899897878)), genderMatters: false, playersGender: "Male", joinedPlayersUUID: ["shdjhfjdfjdgf"], gameChatroomID: "gameChatroomID"), id: "dfhdjfhjehueg"))
    }
}
