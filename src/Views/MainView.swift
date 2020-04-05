//
//  ContentView.swift
//  DistContactTracing
//
//  Created by Axel Backlund on 2020-03-02.
//  Copyright © 2020 Axel. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var showModal = false
    @State private var falseFalse = false
    
    var body: some View {
        ZStack { Color(Asset.offWhite.color).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Safe Contact Tracing")
                    .font(.system(size: 40))
                    .foregroundColor(Color(Asset.niceRed.color))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                GeometryReader { geo in
                    Image(uiImage: Asset.backgroundPeople.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width)
                        .clipped()
                        .padding(.vertical, 12.0)
                }
                Spacer()
                
                InfoBox(
                    title: "How it works",
                    icon: "info.circle",
                    paragraph: "By matching interactions from people marked as sick in COVID-19 with interactions stored locally on your device, you'll get notified if you have been in their proximity and thus if you should get tested."
                )
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 15)
                
                Button(action: {
                    print("Start tracing")
                    self.showModal = true
                }) {
                    Text(showModal ? "Tracing" : "Start tracing")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(showModal ? Color(UIColor.green) : Color(Asset.actionBlue.color))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }.frame(maxWidth: .infinity).padding(.vertical, 20).padding(.horizontal, 15)
            }.sheet(isPresented: self.$showModal) {
                BTDebugView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
