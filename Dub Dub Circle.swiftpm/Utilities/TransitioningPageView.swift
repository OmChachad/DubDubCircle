//
//  TransitioningPageView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/3/25.
//

import SwiftUI

struct TransitioningPageView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var index = 0
    
    var body: some View {
        Group(subviews: content) { collection in
            PageHandler(collection: collection)
        }
    }
    
    private struct PageHandler: View {
        var collection: SubviewsCollection
        @State private var index = 0
        var maxIndex = 0
        
        @State private var offset: CGSize = .zero
        
        @Environment(\.colorScheme) var colorScheme
        
        init(collection: SubviewsCollection, index: Int = 0, maxIndex: Int = 0) {
            self.collection = collection
            self.index = index
            self.maxIndex = collection.count - 1
        }
        
        @State private var rotation = 0
        
        @Namespace var nm
        var body: some View {
            
            collection[index]
                .id(index)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .transition(.blurReplace)
                .animation(.default, value: index)
                .rotationEffect(.degrees(Double(rotation)))
                .gesture (
                    DragGesture()
                        .onEnded { drag in
                            drag.translation.width > 0 ? previous() : next()
                        }
                )
                .overlay {
                    HStack {
                        ForEach(0..<collection.count) { i in
                            Circle()
                                .fill(i == index ? (colorScheme == .dark ? Color.white : Color.black) : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                                .onTapGesture {
                                    withAnimation {
                                        index = i
                                    }
                                }
                        }
                    }
                    .padding(7.5)
                    .background(.ultraThinMaterial, in: .capsule)
                    .matchedGeometryEffect(id: "page", in: nm)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
        }
        
        func next() {
            rotate(by: 100)
            
            withAnimation {
                index = index == maxIndex ? 0 : index + 1
            }
        }
        
        func previous() {
            rotate(by: -100)
            
            withAnimation {
                index = index == 0 ? maxIndex : index - 1
            }
        }
        
        func rotate(by: Int) {
            withAnimation(.bouncy) {
                rotation = by
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                rotation = 0
            }
        }
    }
}

#Preview {
    CircularList {
        Rectangle()
        
        Circle()
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
