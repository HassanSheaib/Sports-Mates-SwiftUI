//
//  ContentView.swift
//  SportMates
//
//  Created by HHS on 18/09/2022.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
 
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        

        VStack{
            if !status {
                NavigationView {
                    LoginScreen()
                }
            }else{
                HomeScreen()
            }
        }
        .onAppear{
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
