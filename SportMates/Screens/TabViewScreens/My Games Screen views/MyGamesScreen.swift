//
//  MyGamesScreen.swift
//  SportMates
//
//  Created by HHS on 22/09/2022.
//

import SwiftUI
import Firebase


struct MyGamesScreen: View {
    
    @StateObject var userVM = UserViewModel()
    @StateObject var gamesListVM = GamesListViewModel()
    @StateObject var addAndDeleteGameVM = AddAndDeleteGamesViewModel()
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    @State var showSignOutAlert = false
    @State var showSpinner = false
    @State var showDetailModal = false
    @Environment(\.presentationMode) var presentationMode

   private func updateScreenContent(){
        userVM.getUserDataByID {
            gamesListVM.getUserJoinedGames(userID: userVM.user.id, gamesIDs: userVM.user.joinedGamesUUID){
            }
        }
    }
    
    var body: some View {
        ZStack{
            Color.black
            VStack{
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(Date(), format: Date.FormatStyle().month().day().weekday(.wide))
                                .font(.footnote)
                                .foregroundColor(Color(.gray))
                        }
                        Text("My Games")
                            .font(.system(size: 24, weight: .bold))
                        
                    }
                    
                    Spacer()
                    Button {
                        self.showSpinner.toggle()
                        addAndDeleteGameVM.deleteAlert = .signOut


                    } label: {
                        Text("Sign Out")
                            .font(.footnote)
                            .padding(4)

                    }
                    .background(Color.red)
                    .cornerRadius(20)
                    .frame(height: 20)

                    

                }
                    .padding()
                    .foregroundColor(.white)
                SafteyTipsView()
                    .padding(.top, 20)
                HStack{
                    Spacer()
                    Text("Drag left to delete or leave game")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .fontWeight(.ultraLight)
                }
                
                if userVM.user.id == "" || showSpinner{
                    Spacer()
                    Spinner()
                    Spacer()
                }else{
                        List {
                            ForEach(gamesListVM.games){ game in
                                GameView(game: game)
                                    .onTapGesture {
                                        self.addAndDeleteGameVM.game = game
                                        self.hapticImpact.impactOccurred()
                                        self.showDetailModal = true
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            self.showSpinner.toggle()
                                            addAndDeleteGameVM.game = game
                                            if userVM.id == game.creatorUUID{
                                                addAndDeleteGameVM.deleteAlert = .deleteGame
                                            }else{
                                                addAndDeleteGameVM.deleteAlert = .leaveGame
                                            }
                                        } label: {
                                            if userVM.id == game.creatorUUID{
                                                Label("Delete", systemImage: "trash")
                                            }else{
                                                Label("Leave", systemImage: "rectangle.portrait.and.arrow.right")
                                            }
                                        }
                                    }
                            }
                        }
                }
            }
            .sheet(isPresented: $showDetailModal, content: {
                GameDetailScreen(gameID: addAndDeleteGameVM.game.id)
            })

            .alert(using: $addAndDeleteGameVM.deleteAlert) { alert in
                switch alert {

                case .deleteGame:
                    return Alert(
                        title: Text("Delete Game"),
                        message: Text("All game data will be lost!! You can Create a game again from the games screen."),
                        primaryButton: .destructive(Text("Delete")) {
                            addAndDeleteGameVM.deleteGame {
                                updateScreenContent()
                                self.showSpinner.toggle()
                            }
                        },
                        secondaryButton: .cancel(Text("Cancel")){
                            self.showSpinner.toggle()
                            
                        }
                    )
                case .leaveGame:
                    return Alert(
                        title: Text("Leave Game"),
                        message: Text("You can join the game again from the games list page."),
                        primaryButton: .destructive(Text("Leave")) {
                            addAndDeleteGameVM.leaveGame(user: userVM.user) {
                                updateScreenContent()
                                self.showSpinner.toggle()
                            }
                        },
                        secondaryButton: .cancel(Text("Cancel")){
                            self.showSpinner.toggle()
                        }
                    )
                case .signOut:
                    return Alert(
                        title: Text("Sign Out"),
                        message: Text("Signed in As \(userVM.user.name) with \(userVM.user.provider) : \(userVM.user.email). are you sure want to sign out?"),
                        primaryButton: .destructive(Text("Sign Out")) {
                            
                            try! Auth.auth().signOut()
                            UserDefaults.standard.set(false, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            
                        },
                        secondaryButton: .cancel(Text("Cancel")){
                            self.showSpinner.toggle()
                        }
                    )
                }
            }
            .task{
                self.updateScreenContent()
            }
        }
    }
}



struct MyGamesScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyGamesScreen()
    }
}
