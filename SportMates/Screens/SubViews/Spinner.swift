//
//  Spinner.swift
//  SportMates
//
//  Created by HHS on 28/09/2022.
//

import SwiftUI



struct Spinner: View {

    @State var image = "cycling-1"
    @State var goUpward = false
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    let constants = Constants()
    @State var counter = 0
    
    
    var body: some View {
            Image(image)
            .resizable()
            .frame(width: 60, height: 60)
            .onReceive(timer) { time in
                
                if counter == constants.spinnerArray.count {
                    counter = 0
                    image = constants.spinnerArray[counter]
                } else {
                        image = constants.spinnerArray[counter]
                        counter += 1
                    }
                }
        }
    }
struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner()
    }
}


