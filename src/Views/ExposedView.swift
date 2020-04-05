//
//  ExposedView.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-05.
//

import SwiftUI

struct ExposedView: View {
    let fhmURL = "https://www.folkhalsomyndigheten.se/smittskydd-beredskap/utbrott/aktuella-utbrott/covid-19/skydda-dig-och-andra/information-pa-olika-sprak/engelska/"
    
    var body: some View {
        ZStack { Color(Asset.offWhite.color).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("You have been nearby an infected person")
                    .font(.system(size: 40))
                    .foregroundColor(Color(Asset.niceRed.color))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                Spacer()
                
                InfoBox(
                    title: "What to do now",
                    icon: "questionmark.circle",
                    paragraph: "Get tested as soon as you can. If you have symptoms, stay at home. Follow instructions from authorities."
                ).padding(.horizontal, 15)
                
                Button(action: {
                    print("Info from Folkhälsomyndigheten")
                    guard let url = URL(string: self.fhmURL) else { return }
                    UIApplication.shared.open(url)
                }) {
                    Text("Info from Folkhälsomyndigheten")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color(Asset.actionBlue.color))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }.frame(maxWidth: .infinity).padding(.top, 20).padding(.horizontal, 15)
                
                Button(action: {
                    print("Dismiss")
                }) {
                    Text("OK")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color(Asset.niceRed.color))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }.frame(maxWidth: .infinity).padding(.bottom, 20).padding(.horizontal, 15).padding(.top, 10)
            }
        }
    }
}

struct ExposedView_Previews: PreviewProvider {
    static var previews: some View {
        ExposedView()
    }
}
