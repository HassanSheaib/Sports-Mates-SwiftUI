//
//  TestView.swift
//  SportMates
//
//  Created by HHS on 08/11/2022.
//

import SwiftUI
import Firebase

struct LoginScreen: View {
    @ObservedObject private var firestoreManger = FirestoreManager()
    @ObservedObject  var signInWithGoogle = SignInWithGoogle()
    @ObservedObject  var signInWithFacebook = SignInWithFacebook()

    
    

    var body: some View {
        VStack (spacing: 10){
            if signInWithGoogle.showSpinner || signInWithFacebook.showSpinner{
                Spacer()
                Spinner()
                Spacer()
            }else{
                HeaderComponent()

                // Sign In with Facebook Button
                Image("LoginScreenPicture")
                    .resizable()
                    .frame(height: 300)
                Text("One more step and you're good to go!")
                    .font(.system(.footnote, design: .serif))
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Button {
                    self.signInWithFacebook.showSpinner.toggle()
                    self.signInWithFacebook.signIn()

                } label: {
                    HStack {
                        Image("facebook-icon")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .accessibility(label: Text("Continue with Facebook"))
                        Spacer()
                        Text("Continue with Facebook ")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .background(Color("FacebookButtonColor"))
                    .cornerRadius(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color("FacebookButtonColor"), lineWidth: 5)
                    )
                    .frame(width: UIScreen.main.bounds.width - 30, height: 40)
                    .padding(.horizontal)
                }
                // Sign in with google Button
                Button {
                    signInWithGoogle.showSpinner.toggle()
                    signInWithGoogle.signIn()

                } label: {
                    HStack {
                        Image("google-icon")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .accessibility(label: Text("Sign in with Google"))
                        Spacer()
                        Text("Sign in with Google")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(.white, lineWidth: 5)
                    )
                    .frame(width: UIScreen.main.bounds.width - 30, height: 40)
                    .padding(.horizontal)
                }
            }
        }
        
        .alert(isPresented: $signInWithFacebook.showError, content: {
            return Alert(
                title: Text("Error Signning In"),
                message: Text(signInWithFacebook.errorMessage)
            
            )
        })
        .fullScreenCover(isPresented: $signInWithFacebook.gotToInfoRegistrationScreen) {
            InfoRegistrationScreen(email: signInWithFacebook.email, userName: signInWithFacebook.username, userUIID:  signInWithFacebook.userID, loginProvider: "Facebook")
        }
        .fullScreenCover(isPresented: $signInWithGoogle.goToInfoRegistrationFromGoogleLogin) {
            InfoRegistrationScreen(email: signInWithGoogle.email, userName: signInWithGoogle.username, userUIID: signInWithGoogle.userID, loginProvider: "Google")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
