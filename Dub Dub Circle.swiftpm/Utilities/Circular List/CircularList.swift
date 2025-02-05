//
//  SwiftUIView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/2/25.
//

import SwiftUI

struct CircularList<Content:View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    let radius = 200.0
                    
                    Group(subviews: content) { collection in
                        collection.first
                            .frame(width: 175, height: 175)
                            .zIndex(1)
                        
                        let ranges = splitIntoRanges(count: collection.count, size: 7)
                        
                        TransitioningPageView {
                            ForEach(Array(ranges.enumerated()), id: \.offset) { offset, range in
                                VStack {
                                    ZStack {
                                        ForEach(collection[range].indices, id: \.self) { index in
                                            let maxSize = (collection.count - 1) > range.upperBound ? range.count : collection.count - range.lowerBound
                                            
                                            let angle = (Angle.degrees(Double(index - (7*offset)) / Double(maxSize) * 360))
                                            let x = cos(angle.radians) * radius
                                            let y = sin(angle.radians) * radius
                                            
                                            collection[range][index]
                                                .glow()
                                                .frame(width: 100, height: 100)
                                                .position(
                                                    x: geometry.size.width / 2 + x,
                                                    y: geometry.size.height / 2 + y
                                                )
                                                .transition(.blurReplace)
                                        }
                                    }
                                    .onAppear {
                                        print(range.upperBound)
                                        print(range.lowerBound)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func splitIntoRanges(count: Int, size: Int = 2) -> [Range<Int>] {
        return stride(from: 1, to: count, by: size).map {
            $0..<$0 + size
        }
    }
}

#Preview {
    CircularList {
        Circle()
            .foregroundStyle(.orange)
        
        Rectangle()
        Circle()
        Circle()
        Circle()
        Circle()
        Circle()
        Circle()
        
        Rectangle()
        Circle()
        Circle()
        Circle()
        Circle()
        Circle()
        Circle()
        
        Circle()
        Circle()
    }
}
