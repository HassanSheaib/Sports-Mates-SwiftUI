//
//  SignInWithGoogle.swift
//  SportMates
//
//  Created by HHS on 08/11/2022.
//

import Foundation
import Firebase
import GoogleSignIn

class SignInWithGoogle: NSObject, ObservableObject{
    
    static let instance = SignInWithGoogle()
    @Published var email = ""
    @Published var username = ""
    @Published var userID = ""

    @Published var goToInfoRegistrationFromGoogleLogin = false
    @Published var showSpinner = false
    
    @Published var showError = false
    @Published var errorMessage = ""

    func signIn() {
      // 1
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUser(for: user, with: error)
        }
      } else {
        // 2
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.showSpinner = false
            return
        }
        
        // 3
        let configuration = GIDConfiguration(clientID: clientID)
        
        // 4
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            self.showSpinner = false
            return
            
        }
        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            self.showSpinner = false
            return
        }
        
        // 5
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
          authenticateUser(for: user, with: error)
        }
      }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            self.errorMessage = error.localizedDescription
            self.showError.toggle()
            self.showSpinner = false
            return
        }

        // 2
        guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            self.showSpinner = false
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

        // 3
        Auth.auth().signIn(with: credential) { [unowned self] (result , error) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
            } else {
                self.email = user?.profile?.email ?? "Unknow"
                self.username = user?.profile?.name ?? "Unknow"
                self.userID = result?.user.uid ?? "Unknown"
                
                FirestoreManager().getUserData(userUIID: self.userID) { userInfo in
                    if userInfo.id == ""{
                        self.showSpinner = false
                        self.goToInfoRegistrationFromGoogleLogin.toggle()
                    }else{
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
            }
        }
    }
}
