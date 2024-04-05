//
//  ChatScreen.swift
//  SportMates
//
//  Created by HHS on 22/09/2022.
//

import SwiftUI

struct ChatScreen: View {
    
    enum Field: Hashable {
           case myField
       }
    @Environment(\.presentationMode) var presentationMode

    @StateObject var userChatroomVM = ChatroomViewModel()
    @State var chatroomID: String
    @State var userID: String
    @State var username: String

    @State var chatMessages : [Message]
    @State var chatTitle : String
    
    @State var chatText = ""
    @FocusState private var focusedField: Field?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            messagesView
                .padding(.top)
                .onTapGesture {
                    focusedField = nil
                }
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 16) {
                    ZStack {
                        DescriptionPlaceholder()
                        TextEditor(text: $chatText)
                            .focused($focusedField, equals: .myField)
                            .opacity(chatText.isEmpty ? 0.5 : 1)
                    }
                    
                    .frame(height: 40)
                    
                    Button {
                        userChatroomVM.sendMessage(message: chatText, username: username, userID: userID, gameChatroomID: chatroomID) {
                            userChatroomVM.loadMessage(chatroomID: chatroomID) { messages in
                                self.chatMessages = messages
                                self.chatText = ""
                            }
                        }
                    } label: {
                        Text("Send")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.accentColor)
                    .cornerRadius(4)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(colorScheme == .dark ? Color.black.ignoresSafeArea() : Color.white.ignoresSafeArea())

            }
        }
        .task {
            userChatroomVM.loadMessage(chatroomID: chatroomID) { messages in
                self.chatMessages = messages
            }
        }
        .onAppear {
            withAnimation {
                presentationMode.wrappedValue.dismiss()                
            }
        }

        .navigationTitle(chatTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        
        
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(chatMessages) { message in
                    ChatBubbleView(userID: userID, message: message)
                }
                HStack{ Spacer() }
                    .id("Empty")
                    .frame(height: 70)
            }
            .onChange(of: chatMessages.count) {_ in
                withAnimation(.easeOut(duration: 0.5)) {
                    proxy.scrollTo("Empty", anchor: .bottom)
                }
            }
            .onAppear(perform: {
                withAnimation(.easeOut(duration: 0.5)) {
                    proxy.scrollTo("Empty", anchor: .bottom)
                }
            })
        }
    }

    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $chatText)
                    .opacity(chatText.isEmpty ? 0.5 : 1)
            }
            
            .frame(height: 40)
            
            Button {
                userChatroomVM.sendMessage(message: chatText, username: username, userID: userID, gameChatroomID: chatroomID) {
                    userChatroomVM.loadMessage(chatroomID: chatroomID) { messages in
                        self.chatMessages = messages
                        self.chatText = ""
                    }
                }
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.accentColor)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Type here")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatScreen(chatroomID: "", userID: "", username: "Hassan", chatMessages: [Message(id: "", userName: "hassan", message: "dhfjdhfjdhfjd", userID: "", timeStamp: Date())], chatTitle: "I Love Uou")
        }
    }
}
