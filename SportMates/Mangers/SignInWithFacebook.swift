//
//  SignInWithFacebook.swift
//  SportMates
//
//  Created by HHS on 10/11/2022.
//

import Foundation
import Firebase
import FBSDKLoginKit

class SignInWithFacebook: NSObject, ObservableObject{
    
    static let instance = SignInWithFacebook()
    @Published var email = ""
    @Published var username = ""
    @Published var userID = ""

    var manger  = LoginManager()
    @Published var showSpinner = false
    @Published var gotToInfoRegistrationScreen = false


    @Published var showError = false
    @Published var errorMessage = ""

    func signIn() {
        manger.logIn(permissions: ["public_profile", "email"], from: nil) { (result, err) in
            if err != nil{
                print(err!.localizedDescription)
                self.errorMessage = err!.localizedDescription
                self.showError.toggle()
                self.showSpinner = false
                return
                
            }
            if AccessToken.current?.hasGranted("public_profile") == true  &&  AccessToken.current?.hasGranted("email") == true {
                if !result!.isCancelled{
                    if AccessToken.current != nil {
                        
                        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                        Auth.auth().signIn(with: credential) {(res ,  er) in
                            
                            if er != nil{
                                print((er?.localizedDescription)!)
                                self.errorMessage = er!.localizedDescription
                                self.showError = true
                                self.showSpinner = false
                                return
                            }
                            if !result!.isCancelled{
                                let request = GraphRequest(graphPath: "me", parameters: ["fields" : "email"])
                                request.start{ (_, result, _)in
                                    guard let profileData = result as? [String : Any] else{return}
                                    self.email = profileData["email"] as? String ?? profileData["id"] as! String
                                    self.username = res?.user.displayName ?? "Unknown"
                                    self.userID = res?.user.uid ?? "Unknown"
                                    FirestoreManager().getUserData(userUIID: self.userID) { userInfo in
                                        if userInfo.id == ""{
                                            self.gotToInfoRegistrationScreen.toggle()

                                        }else{
                                            UserDefaults.standard.set(true, forKey: "status")
                                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                        }
                                        self.showSpinner = false
                                    }
                                }
                            }
                        }
                    }
                }else{
                    self.showSpinner = false
                }
            }else{
                self.showSpinner = false
                self.manger.logOut()
                self.errorMessage = "You Need To Grant Sports Mates All the requested permissions (Public profile & Email, Your Facebook username will be used as your username inside the app."
                self.showError.toggle()
            }

        }

    }
    

}

