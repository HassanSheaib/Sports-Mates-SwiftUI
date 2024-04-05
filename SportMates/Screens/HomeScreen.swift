//
//  HomeScreen.swift
//  SportMates
//
//  Created by HHS on 20/09/2022.
//

import SwiftUI
import Firebase

struct HomeScreen: View {
    @ObservedObject private var firestoreManger = FirestoreManager()
    @Environment(\.colorScheme) var colorScheme

    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("ColorBlackLight"))
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        
    }
    var body: some View {
        VStack{
                TabView{
                    GamesScreen()
                        .tabItem ({
                            Image(systemName: "basketball.fill")
                            Text("Available Games")

                        })
                    MainMessagesView()
                        .tabItem ({
                            Image(systemName: "message")
                            Text("Chat")
                        })
                    MyGamesScreen()
                        .tabItem ({
                            Image(systemName: "figure.soccer")
                            Text("My Games")
                        })
                    GamesTips()
                        .tabItem ({
                            Image(systemName: "info")
                            Text("Guide")
                        })
                }
                .navigationTitle("")
                .navigationBarBackButtonHidden(true)            
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
