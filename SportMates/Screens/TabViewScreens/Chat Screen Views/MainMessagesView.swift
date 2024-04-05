//
//  TestView.swift
//  SportMates
//
//  Created by HHS on 10/10/2022.
//

import SwiftUI

struct MainMessagesView: View {

    
    @StateObject var userVM = UserViewModel()
    @StateObject var userChatroomVM = ChatroomViewModel()
    @State var chatRooms: [ChatRoomModel] = []
    @Environment(\.colorScheme) var colorScheme

    @State var shouldNavigateToChatLogView = false
    @State var date = Date()
    var navBarTitle = "My Games Chatrooms"
    
    
    var body: some View {
        
            NavigationView {
                ZStack{
                    Color.black
                VStack {
                    customNavBar
                        .padding(.vertical)
                        .foregroundColor(.white)
                    if chatRooms.isEmpty{
                        Spacer()
                        Text("you are not in Any Game Chatroom!!")
                        Spacer()
                    }else{
                        ChatroomsView
                            .padding(.top)
                            .background(colorScheme == .dark ? Color.black: Color.white)
                            .navigationBarHidden(true)
                    }

                }
                .task {
                    print("Hello")
                    userVM.getUserDataByID {
                        userChatroomVM.getMyChatroom(userID: userVM.user.id, chatroomID: userVM.user.gamesChatroomsUUIDs) { chatrooms in
                            
                            self.chatRooms = chatrooms.sorted(by: {$0.gameDate > $1.gameDate})
                        }
                    }
                }
            }
        }
    }
    private var customNavBar: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(date, format: Date.FormatStyle().month().day().weekday(.wide))
                        .font(.footnote)
                        .foregroundColor(Color(.gray))
                }
                Text(navBarTitle)
                    .font(.system(size: 24, weight: .bold))

            }

            Spacer()
        }
        .padding(.horizontal)

    }

    private var ChatroomsView: some View {
        ScrollView {
            ForEach(self.chatRooms) { chatroom in
                NavigationLink {
                    ChatScreen(chatroomID: chatroom.id, userID: userVM.user.id, username: userVM.user.name, chatMessages: chatroom.messages, chatTitle: chatroom.gameName)
                } label: {
                    VStack {
                        HStack(spacing: 16) {
                            Image(chatroom.gameName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                )


                            VStack(alignment: .leading) {
                                Text("\(chatroom.gameName)")
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                                
                                Text(chatroom.messages[chatroom.messages.count - 1].message)
                                    .lineLimit(2)
                                    .font(.system(size: 8))
                                    .foregroundColor(Color(.lightGray))
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()

                            Text(chatroom.messages[chatroom.messages.count - 1].timeStamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.system(size: 8, weight: .light))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        Divider()
                            .padding(.vertical, 8)
                    }.padding(.horizontal)
                }


            }.padding(.bottom, 50)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
