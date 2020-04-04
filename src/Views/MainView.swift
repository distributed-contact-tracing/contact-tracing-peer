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
                Image(uiImage: Asset.backgroundPeople.image)
                    .padding(.vertical, 12.0)
                Spacer()
                ZStack {
                    VStack {
                        HStack {
                            Image(systemName: "info.circle").font(.system(size: 30.0))
                            Text("How it works")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .padding(.leading, 7)
                            Spacer()
                        }.padding(.bottom, 10).padding(.horizontal, 20).padding(.top, 20)
                        Text("By matching interactions from people marked as sick in COVID-19 with interactions stored locally on your device, you'll get notified if you have been in their proximity and thus if you should get tested.")
                            .foregroundColor(Color(Asset.offBlack.color))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }.background(Color.white).cornerRadius(10).shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 10, y: 5)
                }.padding(.horizontal, 15)
                
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
            }.sheet(isPresented: self.$falseFalse) {
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
