//
//  InfoRegistrationScreen.swift
//  SportMates
//
//  Created by HHS on 26/09/2022.
//

import SwiftUI
import Firebase

struct InfoRegistrationScreen: View {
    
    //MARK: Proprities
    
    //AlertMessageEnums
    
    enum ErrorAlert {
        case noErrors
        case nameNotSet
        case ageNotSet
        case genderNotSet
    }
    
    @State private var errorAlert: ErrorAlert?
    
    // Firestore Object
    let constants = Constants()
    @ObservedObject private var firestoreManger = FirestoreManager()
    @StateObject private var addUserVM = UserViewModel()
    // Data to be stored in the firebase
    @State var  email : String
    @State var userName : String
    @State var userUIID : String
    @State var loginProvider :String
    
    // View Data
    let  genderArray = ["Male", "Female"]
    @State var alertMsg = ""
    @State var showInfoRegistrationScreen = false
    
    
    
    //MARK: FUNCTIONS
    private func checkEnteredData(yearOfBirth: String, gender: String) -> ErrorAlert{
        var errAlert : ErrorAlert = .noErrors
        
        if yearOfBirth == ""{
            errAlert = .ageNotSet
            print(errAlert)
        }else if gender == ""{
            errAlert = .genderNotSet
            print(errAlert)
        }
        return errAlert
    }
    
    
    func saveUserData( yearOfBirth: String, gender: String){
        
        let alert = checkEnteredData(yearOfBirth: yearOfBirth, gender: gender)
        addUserVM.name = userName
        if alert == .noErrors {
            addUserVM.saveUserData(provider: loginProvider, email: email)
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
        }else{
            self.errorAlert = alert
            
        }
    }
    
    var body: some View {
        
        VStack {
            if showInfoRegistrationScreen{
                VStack {
                    HeaderView(title: "User information", note: "your informations will be used to present you with the games that best suits you", color: .white, image: "AllSports")
                        .frame(height: 200)
                        .ignoresSafeArea()
                    Form{
                        Section() {
                            Text(userName)
                        }
                        
                        Section(header: Text("set your Age")) {
                            HStack{
                                Text("Year of birth")
                                
                                Picker("", selection: $addUserVM.yearOfBirth) {
                                    ForEach(constants.yearsRange, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                        }
                        
                        Section(header: Text("Gender")) {
                            Picker("", selection: $addUserVM.gender) {
                                ForEach(genderArray, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                        }
                    }

                    Button {
                        self.saveUserData(yearOfBirth: addUserVM.yearOfBirth, gender: addUserVM.gender)
                        
                    } label: {
                        Text("Send")
                            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        
                    }
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    
                    Spacer()
                    Spacer()
                }
                .navigationTitle("")
                .navigationBarBackButtonHidden(true)
            }else{
                Spinner()
            }
        }
        .alert(using: $errorAlert) { alert in
            switch alert {
            case .nameNotSet:
                return Alert(title: Text("Name Not Valid"), message: Text("Please make sure to enter a valid name."))
            case .ageNotSet:
                return Alert(
                    title: Text("Age Not Valid"),
                    message: Text("Please enter your age")
                )
            case .genderNotSet:
                return Alert(title: Text("Gender Not set"), message: Text("Please choose your gender"))
            case .noErrors:
                return Alert(title: Text("All Good "), message: Text("You Can Enjoy our app shortly"))
                
            }
        }
        .onChange(of: addUserVM.yearOfBirth, perform: { newValue in
            print("HOHOHO")
            print(addUserVM.yearOfBirth)
        })

        .task {
            addUserVM.getUserDataByID(){
                print(addUserVM.user.id)
            }
            print(addUserVM.user.id)
            if addUserVM.user.id == "" {
                self.showInfoRegistrationScreen.toggle()
            }else{
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }
        }
    }
}


struct InfoRegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoRegistrationScreen(email: "76135537", userName: "Hassan", userUIID: "jshdjwhgfuwgdqiuwgi", loginProvider: "Google")
    }
}
