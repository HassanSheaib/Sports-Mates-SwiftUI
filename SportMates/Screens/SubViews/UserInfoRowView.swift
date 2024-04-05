//
//  UserInfoRowView.swift
//  SportMates
//
//  Created by HHS on 03/11/2022.
//

import SwiftUI

struct UserInfoRowView: View {
    
    var gender: String
    var age : String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 12) {
            Spacer()
            HStack(alignment: .center, spacing: 2) {
                Image("gender")
                    .resizable()
                    .modifier(IconCustomizer())
                VStack{
                    Text(" \(gender)").lineLimit(1)
                }
            }
            Spacer()

            HStack(alignment: .center, spacing: 2) {
                Image("age")
                    .resizable()
                    .modifier(IconCustomizer())
                VStack{
                    Text(" \(age) years").lineLimit(1)
                }
            }
            Spacer()

        }
        .font(.footnote)
        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
        .padding(.horizontal)
        .foregroundColor(.white)
        .background(Color("ColorBlackLight"))
        .cornerRadius(12)
    }
}


struct UserInfoRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoRowView(gender: "Male", age: "27")
    }
}
