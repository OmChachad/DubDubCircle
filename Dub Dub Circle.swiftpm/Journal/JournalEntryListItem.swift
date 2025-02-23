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
            
            Text(entry.title)
                .font(.title3)
                .bold()
            
            if let contents = entry.contents?.asAttributedString {
                Text(contents)
                    .font(.body)
            }
            
            Divider()
            
            HStack {
                Text(entry.date, style: .date)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Menu("Actions", systemImage: "ellipsis") {
                    Button("Edit", systemImage: "pencil") {
                        showEditSheet = true
                    }
                    
                    Divider()
                    
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
                .labelStyle(.iconOnly)
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
        .sheet(isPresented: $showEditSheet) {
            NewJournalEntryView(editing: entry)
        }
    }
}
