//
//  JournalEntryListItem.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

import Foundation
import SwiftUI

struct JournalEntryListItem: View {
    @Environment(\.modelContext) var modelContext
    
    var entry: JournalEntry
    
    @State private var showDeleteConfirmation = false
    @State private var showEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if !entry.relatedAttendees.isEmpty {
                HStack {
                    AttendeeCircles(attendees: entry.relatedAttendees, maxCount: 5, height: 50, offset: 30, addPlaceholders: false)
                    
                    if entry.relatedAttendees.count > 5 {
                        Text("and \(entry.relatedAttendees.count - 5) more")
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Related attendees: \(entry.relatedAttendees.prefix(5).map { $0.name }.joined(separator: ", "))\(entry.relatedAttendees.count > 5 ? " and \(entry.relatedAttendees.count - 5) more" : "")")
            }
            
            Text(entry.title)
                .font(.title3)
                .bold()
                .accessibilityAddTraits(.isHeader)
            
            if let contents = entry.contents?.asAttributedString {
                Text(contents)
                    .font(.body)
            }
            
            Divider()
            
            HStack {
                Text(entry.date, style: .date)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Date: \(entry.date.formatted(date: .long, time: .omitted))")
                
                Spacer()
                
                Menu("Actions", systemImage: "ellipsis") {
                    Button("Edit", systemImage: "pencil") {
                        showEditSheet = true
                    }
                    .accessibilityLabel("Edit entry")
                    .accessibilityHint("Double tap to edit this journal entry")
                    
                    Divider()
                    
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                    .accessibilityLabel("Delete entry")
                    .accessibilityHint("Double tap to delete this journal entry")
                }
                .labelStyle(.iconOnly)
                .accessibilityLabel("Entry actions")
                .accessibilityHint("Double tap to edit or delete this entry")
                .alert("Are you sure you want to delete this journal entry?", isPresented: $showDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        modelContext.delete(entry)
                        try? modelContext.save()
                    }
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(uiColor: .systemGray6))
                .shadow(color: Color.black.opacity(0.2), radius: 5)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Journal entry: \(entry.title)")
        .sheet(isPresented: $showEditSheet) {
            NewJournalEntryView(editing: entry)
        }
    }
}
