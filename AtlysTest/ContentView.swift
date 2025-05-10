//
//  ContentView.swift
//  AtlysTest
//
//  Created by Piyush on 11/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CarouselView(images: ["img1","img2","img3"])
                            .frame(height: 220)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
