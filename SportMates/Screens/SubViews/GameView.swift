//
//  GameView.swift
//  SportMates
//
//  Created by HHS on 08/10/2022.
//

import SwiftUI
import CoreLocation

struct GameView: View {
    var game : GameViewModel
    @Environment(\.colorScheme) var colorScheme
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    var gameDateString : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        let date = formatter.string(from: game.date)
        return date
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(game.sportName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 4)
                VStack(alignment: .leading, spacing: 8) {
                    HStack{
                        // Game Informations
                        VStack(alignment: .leading){
                            HStack(alignment: .center, spacing: 2) {
                                Image(systemName: "calendar")
                                Text("\(gameDateString), at \(game.time).")
                            }
                            HStack(alignment: .center, spacing: 2) {
                                Image(systemName: "person.3")
                                Text("\(game.currentNumberOfPlayers) from \(game.idealNumberOfPlayers), For \(game.playersLevels).")
                                    .lineLimit(1)
                            }.padding(.top, 4)
                        }
                    }
                }
                Spacer()
            }
        }
        .font(.callout)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: GameViewModel(game: Game(creatorUUID: "", creatorName: "", creatorGender: "", creatorAge: "", sportName: "Football", date: Date(), time: "8:00PM", duration: "1hr", gamePurpose: "For Fun", playersLevels: "Beginner", minNumberOfplayers: 9, idealNumberOfPlayers: 12, minPlayersAge: 19, maxPlayersAge: 60, currentNumberOfPlayers: 1, location: LocationModal(cityName: "AN Nabatieh", gouvernate: "An Nabatieh", country: "Lebanon", coordinate: CLLocationCoordinate2D(latitude: 33.08988786767, longitude: 34.0899897878)), genderMatters: false, playersGender: "Male", joinedPlayersUUID: ["shdjhfjdfjdgf"], gameChatroomID: "gameChatroomID"), id: "dfhdjfhjehueg"))
        
    }
}
