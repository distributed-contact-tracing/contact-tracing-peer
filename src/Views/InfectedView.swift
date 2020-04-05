//
//  InfectedView.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-05.
//

import SwiftUI

struct InfectedView: View {
    @State var isLoading = false
    
    var body: some View {
        ZStack { Color(Asset.offWhite.color).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Test result: Positive")
                    .font(.system(size: 40))
                    .foregroundColor(Color(Asset.niceRed.color))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                Spacer()
                
                InfoBox(
                    title: "What to do now",
                    icon: "questionmark.circle",
                    paragraph: "Your COVID-19 test showed that you are infected with the SARS-CoV-2 virus. To anonymously notify the people you have been around and possibly infected, press the button."
                ).padding(.horizontal, 15)
                
                Button(action: {
                    print("Share data")
                    self.isLoading = true
                    InfectionManager.shared.uploadInfectedInteractions { error in
                        self.isLoading = false
                    }
                }) {
                    Text(isLoading ? "Sharing..." : "Share my data")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color(Asset.actionBlue.color))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }.disabled(isLoading).frame(maxWidth: .infinity).padding(.vertical, 20).padding(.horizontal, 15)
            }
        }
    }
}

struct InfectedView_Previews: PreviewProvider {
    static var previews: some View {
        InfectedView()
    }
}
