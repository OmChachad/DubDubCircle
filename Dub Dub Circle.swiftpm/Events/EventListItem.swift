//
//  EventListItem.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/5/25.
//

import SwiftUI

struct EventListItem: View {
    @Environment(\.modelContext) var modelContext
    
    var event: DeveloperEvent
    
    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack {
            AttendeeCircles(attendees: event.attendees)
            
            VStack(alignment: .leading) {
                Group {
                    Text(event.title)
                        .font(.headline)
                    //                +
                    Text((event.location?.name ?? "Online"))
                        .opacity(0.6)
                }
                .lineLimit(1)
                
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .opacity(0.6)
                
            }
            
            Spacer()
        }
        .swipeActions {
            Button("Delete", systemImage: "trash") {
                showDeleteConfirmation = true
            }
            .tint(.red)
            
            Button("Edit", systemImage: "pencil") {
                showEditSheet = true
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NewEventView(editing: event)
        }
        .alert("Are you sure you want to delete the \(event.title) event?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                modelContext.delete(event)
                try? modelContext.save()
            }
        }
    }
}

#Preview {
    let event = DeveloperEvent(title: "WWDC", date: Date(), wasOnline: true)
    EventListItem(event: event)
}
