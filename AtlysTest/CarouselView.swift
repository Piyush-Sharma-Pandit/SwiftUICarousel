//
//  CarouselView.swift
//  AtlysTest
//
//  Created by Piyush on 11/05/25.
//

import SwiftUI

struct CarouselView: View {
    let images: [String]
    let spacing: CGFloat = -62
    
    @State private var currentIndex: Int = 0
    @State private var midXMap: [Int: CGFloat] = [:]
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let tileSize = height
            let screenMidX = UIScreen.main.bounds.width / 2
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(images.indices, id: \.self) { index in
                        ZStack {
                            GeometryReader { geo in
                                let midX = geo.frame(in: .global).midX
                                let visibleSpacing = tileSize + spacing
                                let halfThreshold = visibleSpacing / 2
                                
                                let scale: CGFloat = {
                                    if midX > screenMidX, midX <= screenMidX + halfThreshold {
                                        let progress = (midX - screenMidX) / halfThreshold
                                        return 0.75 + (0.25 * (1.0 - progress))
                                    } else if midX < screenMidX, midX >= screenMidX - halfThreshold {
                                        let progress = (screenMidX - midX) / halfThreshold
                                        return 1.0 - (0.25 * progress)
                                    } else {
                                        return 0.75
                                    }
                                }()
                                
                                Color.clear
                                    .onAppear {
                                        midXMap[index] = midX
                                        updateCurrentIndex(screenMidX: screenMidX)
                                    }
                                    .onChange(of: midX) { newMidX in
                                        midXMap[index] = newMidX
                                        updateCurrentIndex(screenMidX: screenMidX)
                                    }
                                
                                Image(images[index])
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .frame(width: tileSize, height: tileSize)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .scaleEffect(scale)
                                    .animation(.easeOut(duration: 0.2), value: scale)
                            }
                            .frame(width: tileSize, height: tileSize)
                        }
                        .frame(width: tileSize, height: tileSize)
                        .zIndex(currentIndex == index ? 1 : 0)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width / 2 - tileSize / 2)
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    private func updateCurrentIndex(screenMidX: CGFloat) {
        let closest = midXMap.min(by: {
            abs($0.value - screenMidX) < abs($1.value - screenMidX)
        })?.key
        
        if let closest = closest, closest != currentIndex {
            currentIndex = closest
        }
    }
}
