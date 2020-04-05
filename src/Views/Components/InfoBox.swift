//
//  InfoBox.swift
//  MySharedAir
//
//  Created by Axel Backlund on 2020-04-05.
//

import SwiftUI

struct InfoBox: View {
    let title: String
    let icon: String
    let paragraph: String
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: icon).font(.system(size: 30.0))
                    Text(title)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding(.leading, 7)
                    Spacer()
                }.padding(.bottom, 10).padding(.horizontal, 20).padding(.top, 20)
                Text(paragraph)
                    .foregroundColor(Color(Asset.offBlack.color))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }.background(Color.white).cornerRadius(10).shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 10, y: 5)
        }
    }
}
