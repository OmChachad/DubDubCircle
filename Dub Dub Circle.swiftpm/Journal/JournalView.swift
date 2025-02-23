//
//  JournalView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/21/25.
//

import SwiftUI

struct JournalView: View {
    var event: DeveloperEvent
    
    @State private var showAddEntryView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.invertedPrimary, .invertedPrimary, .indigo.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Group {
                    if event.journalEntries.isEmpty {
                        ContentUnavailableView("No journal entries—yet!", systemImage: "book.pages.fill")
                            .offset(y: -50)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(event.journalEntries) { entry in
                                    JournalEntryListItem(entry: entry)
                                        .transition(.blurReplace)
                                }
                            }
                        }
                        .contentMargins(20, for: .scrollContent)
                        .safeAreaPadding(.bottom, 100)
                        .animation(.default, value: event.journalEntries.count)
                    }
                }
                .overlay(alignment: .bottom) {
                    Button {
                        showAddEntryView = true
                    } label: {
                        Label("Add", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .bold()
                            .tint(.indigo)
                            .padding()
                            .background(.invertedPrimary, in: .circle)
                    }
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        Rectangle()
                            .fill(.indigo.opacity(0.15))
                            .background(.ultraThinMaterial)
                            .mask {
                                Rectangle()
                                    .fill(LinearGradient(colors: [.clear, .white, .white, .white], startPoint: .top, endPoint: .bottom))
                            }
                            .frame(height: 120)
                            .ignoresSafeArea()
                    }
                }
            }
            .sheet(isPresented: $showAddEntryView) {
                NewJournalEntryView(event: event)
            }
            .navigationTitle("\(event.title) Journal")
        }
    }
}

#Preview {
    let event = DeveloperEvent(title: "WWDC", date: Date(), wasOnline: true)
    VStack {}
        .sheet(isPresented: .constant(true)) {
            JournalView(event: event)
        }
}
