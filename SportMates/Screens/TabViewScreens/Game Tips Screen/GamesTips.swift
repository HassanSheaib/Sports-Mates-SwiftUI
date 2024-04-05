//
//  GamesTips.swift
//  SportMates
//
//  Created by HHS on 17/10/2022.
//

import SwiftUI

struct GamesTips: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack{
            HeaderComponent()
            ScrollView(.vertical, showsIndicators: false) {
              VStack(alignment: .center, spacing: 20) {
                
                
                Text("Join The Game!")
                  .font(.system(.title, design: .serif))
                  .fontWeight(.black)
                  .foregroundColor(.white)
                
                
                VStack(alignment: .leading, spacing: 25) {
                    GuideComponent(
                      title: "Create Games",
                      description: "Press on the + button to create a game, you can create 1 game only on a specific date.",
                      icon: "plus.circle")
                    
                  GuideComponent(
                    title: "Join Games",
                    description: "From the list of games you can press on the game you like, after you check the details you can join. ONLY JOIN IF YOU MEET THE GAME REQUIREMENT!",
                    icon: "square.and.arrow.down")
                  
                  GuideComponent(
                    title: "Leave Or Delete",
                    description: "After joining the game you can Leave from the 'My Games' screen if you can no longer play. If the game is created by yourself you can not leave the game but you can delete it.",
                    icon: "rectangle.portrait.and.arrow.forward")
                  
                  GuideComponent(
                    title: "Chatroom",
                    description: "When you join or create a game, you will be added to a chatroom to communicate with other players who joined the game. Only use the chat for game related subject and be respectful",
                    icon: "message")
                }
                Spacer(minLength: 10)
              }
              .frame(minWidth: 0, maxWidth: .infinity)
              .padding(.top, 15)
              .padding(.bottom, 25)
              .padding(.horizontal, 25)
              .background(Color.black)
              .ignoresSafeArea()
            }

        }
    }
}
struct GamesTips_Previews: PreviewProvider {
    static var previews: some View {
        GamesTips()
    }
}
