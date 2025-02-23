//
//  NewJournalEntryView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

import SwiftUI
import SwiftData

struct NewJournalEntryView: View {
    var event: DeveloperEvent
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @State private var date = Date.now
//    @State private var selectedContacts: [Contact] = []
    @State private var contents: NSAttributedString = NSAttributedString(string: "")
    
    @State private var textEditorPadding: CGFloat = 0
    
    var existingEntry: JournalEntry?
    
    init(event: DeveloperEvent) {
        self.event = event
        self.existingEntry = nil
    }
    
    init(editing journalEntry: JournalEntry) {
        self.event = journalEntry.event
        self.existingEntry = journalEntry
        
        self._title = State(initialValue: journalEntry.title)
        self._date = State(initialValue: journalEntry.date)
        self._contents = State(initialValue: journalEntry.contents?.asNSAttributedString ?? NSAttributedString(string: ""))
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.clear, .clear, .indigo.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    TextField("Title", text: $title)
                        .bold()
                    
                    Divider()
                    
                    JournalTextEditor(text: $contents, sidePadding: $textEditorPadding)
                        .padding(-textEditorPadding)
                        .placeholder("Write your thoughts here... (Genmojis are supported!)", contents: contents.string)
                }
                .padding(.horizontal)
                
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                
                ToolbarItem(placement: .principal) {
                    DatePicker("Date", selection: $date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let existingEntry = existingEntry {
                            existingEntry.title = title
                            existingEntry.contents = try? JournalContents(AttributedString(contents))
                            existingEntry.date = date
                        } else {
                            let newJournalEntry = JournalEntry(event: event, title: title, journalContents: AttributedString(contents), date: date)
                            event.journalEntries.append(newJournalEntry)
                        }
                        try? modelContext.save()
                        
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}

#Preview {
    VStack {
        
    }
    .sheet(isPresented: .constant(true)) {
        let event = DeveloperEvent(title: "WWDC", date: Date(), wasOnline: true)
        NewJournalEntryView(event: event)
    }
}
