//
//  UserViewModel.swift
//  SportMates
//
//  Created by HHS on 01/10/2022.
//

import Foundation
import Firebase
import CoreLocation


class UserViewModel: ObservableObject {
    
    
    private var firestoreManager: FirestoreManager

    let id = Auth.auth().currentUser!.uid

    @Published var user = UserModel(id: "", email: "", provider: "", name: "", yearOfBirth: "", gender: "", joinedGamesUUID: [], gamesChatroomsUUIDs: [])
    @Published var saved: Bool = false
    @Published var message: String = ""
    
    enum SignOut {
        case signOut
    }
    
    init() {
        firestoreManager = FirestoreManager()
    }
    @Published var userLocation : CLLocation?
    @Published var name = ""
    @Published var yearOfBirth = ""
    @Published var gender = ""
    @Published var joinedGamesUUID = [String]()
    @Published var gamesChatroomsUUIDs = [String]()
    
    func saveUserData(provider: String, email: String){
        let user = UserModel(id: self.id, email: email, provider: provider, name: self.name, yearOfBirth: self.yearOfBirth, gender: self.gender, joinedGamesUUID: joinedGamesUUID, gamesChatroomsUUIDs: gamesChatroomsUUIDs )
        
        firestoreManager.saveUserDataWithSameUID(userInfo: user) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.saved = user == nil ? false: true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.message = "Game save Failed"
                }
            }
        }
    }
    
    func getUserDataByID(handler: @escaping() -> ()){
        firestoreManager.getUserData(userUIID: self.id) { userInfo in
            self.user = userInfo
            handler()
        }
    }
    
    func getGameCreatorDataByID(gameCreatorID: String, handler: @escaping (_ gameCreator: UserModel) -> ()){
        firestoreManager.getUserData(userUIID: gameCreatorID) { userInfo in
            handler(userInfo)
        }

    }
}
