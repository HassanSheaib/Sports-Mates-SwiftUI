//
//  MessageModel.swift
//  SportMates
//
//  Created by HHS on 10/10/2022.
//

import Foundation

struct ChatRoomModel: Identifiable{
    
    var id: String
    var gameName: String
    var gameDate: Date
    var creatorID: String
    var messages: [Message]
    

}

struct Message: Identifiable {
    
    var id: String
    var userName: String
    var message: String
    var userID: String
    var timeStamp: Date
}

