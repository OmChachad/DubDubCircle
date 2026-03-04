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
                    .accessibilityHidden(true)
                
                Group {
                    if event.journalEntries.isEmpty {
                        ContentUnavailableView("No journal entries—yet!", systemImage: "book.pages.fill")
                            .offset(y: -50)
                            .accessibilityLabel("No journal entries")
                            .accessibilityHint("Tap the add button to create your first journal entry")
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
                        .accessibilityLabel("Journal entries")
                        .accessibilityValue("\(event.journalEntries.count) \(event.journalEntries.count == 1 ? "entry" : "entries")")
                    }
                }
                .overlay(alignment: .bottom) {
                    Button {
                        showAddEntryView = true
                    } label: {
                        Label("Add", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .bold()
                            .foregroundStyle(.indigo)
                            .padding()
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .tint(.invertedPrimary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Add journal entry")
                    .accessibilityHint("Double tap to create a new journal entry")
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
                            .accessibilityHidden(true)
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
