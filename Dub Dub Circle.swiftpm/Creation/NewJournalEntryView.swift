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
    @State private var selectedAttendees: Set<Contact> = []
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
        self._selectedAttendees = State(initialValue: Set<Contact>(journalEntry.relatedAttendees))
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.clear, .clear, .indigo.opacity(0.15)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
                
                VStack {
                    NavigationLink {
                        AttendeePicker(selectedAttendees: $selectedAttendees, event: event)
                    } label: {
                        HStack {
                            if selectedAttendees.isEmpty {
                                Text("Selected Related Attendees")
                            } else {
                                AttendeeCircles(attendees: [Contact](selectedAttendees), maxCount: 5, height: 50, offset: 30, addPlaceholders: false)
                                
                                if selectedAttendees.count > 5 {
                                    Text("and \(selectedAttendees.count - 5) more")
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(selectedAttendees.isEmpty ? "No attendees selected" : "Selected attendees: \(selectedAttendees.prefix(5).map { $0.name }.joined(separator: ", "))\(selectedAttendees.count > 5 ? " and \(selectedAttendees.count - 5) more" : "")")
                    .accessibilityHint("Double tap to select related attendees")
                    
                    TextField("Title", text: $title)
                        .bold()
                        .accessibilityLabel("Journal entry title")
                        .accessibilityHint("Enter a title for this journal entry")
                    
                    Divider()
                    
                    JournalTextEditor(text: $contents, sidePadding: $textEditorPadding)
                        .padding(-textEditorPadding)
                        .placeholder("Write your thoughts here... (Genmojis are supported!)", contents: contents.string)
                        .accessibilityLabel("Journal entry content")
                        .accessibilityHint("Write your journal entry here")
                }
                .padding(.horizontal)
                
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                        .accessibilityLabel("Cancel")
                        .accessibilityHint("Discard changes and close")
                }
                
                ToolbarItem(placement: .principal) {
                    DatePicker("Date", selection: $date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .accessibilityLabel("Entry date")
                        .accessibilityHint("Select the date for this journal entry")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let existingEntry = existingEntry {
                            existingEntry.title = title
                            existingEntry.contents = try? JournalContents(AttributedString(contents))
                            existingEntry.date = date
                            existingEntry.relatedAttendees = [Contact](selectedAttendees)
                        } else {
                            let newJournalEntry = JournalEntry(event: event, title: title, journalContents: AttributedString(contents), date: date, relatedAttendees: [Contact](selectedAttendees))
                            event.journalEntries.append(newJournalEntry)
                        }
                        try? modelContext.save()
                        
                        dismiss()
                    }
                    .disabled((title + contents.string).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .bold()
                    .accessibilityLabel("Save journal entry")
                    .accessibilityHint("Save journal entry and close")
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
