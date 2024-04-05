//
//  ChatroomViewModel.swift
//  SportMates
//
//  Created by HHS on 11/10/2022.
//

import Foundation


class ChatroomViewModel: ObservableObject {
    
    private var firestoreManager: FirestoreManager
    
    
    init() {
        firestoreManager = FirestoreManager()
    }
    
    func getMyChatroom(userID: String, chatroomID : [String], handler: @escaping(_ chatrooms: [ChatRoomModel])  -> ()){
        firestoreManager.getUserChatRooms(userID: userID, chatroomsID: chatroomID) { chatrooms in
            handler(chatrooms)
        }
    }
    
    func sendMessage(message: String, username : String, userID: String, gameChatroomID: String , handler: @escaping() -> ()){
        firestoreManager.sendMessage(message: message, username: username, userID: userID, gameChatroomID: gameChatroomID) {
            handler()
        }
    }
    
    func loadMessage(chatroomID: String, handler: @escaping(_ messages: [Message])  -> ()){
        firestoreManager.loadMessages(gameChatroomID: chatroomID) { messages in
            handler(messages)
        }
    }
    
}
