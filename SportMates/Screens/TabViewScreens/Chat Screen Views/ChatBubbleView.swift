//
//  ChatBubbleView.swift
//  SportMates
//
//  Created by HHS on 12/10/2022.
//

import SwiftUI

struct ChatBubbleView: View {
    @State var userID: String
    @State var message: Message
    
    var bubbleColor: Color {
        if message.userID == "undefined"{
            return Color("ColorBlackLight") 
        }else if userID == message.userID {
            return Color("ChatBubbleColor")
        }else{
            return .blue
        }
    }
    
    var body: some View {
        HStack {
            if userID == message.userID{
                Spacer()
            }
            VStack(alignment: .leading) {
                if message.userID != "undefined"{
                   Text(message.userName)
                        .font(.system(size: 10))

                }
                Text(message.message)
                
                Text(message.timeStamp.formatted(date: .numeric, time: .standard))
                    .fontWeight(.light)
                    .font(.system(size: 8))

            }
            .padding(4)
            .foregroundColor(.white)
            .background(bubbleColor)
            .cornerRadius(8)
            
            if userID != message.userID && userID != "undefined"{
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubbleView(userID: "fdfdfd", message: Message(id: "", userName: "Hassan", message: "hello my dear", userID: "jdfkfjdk", timeStamp: Date()))
    }
}
