//
//  AttendeeItem.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/8/25.
//

import SwiftUI

struct AttendeeItem: View {
    @Environment(\.openURL) var openURL
    @Environment(\.modelContext) var modelContext
    
    var attendee: Contact
    @Namespace var namespace: Namespace.ID
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        NavigationLink {
            AttendeeDetails(attendee: attendee)
                .navigationTransition(.zoom(sourceID: "\(attendee.id.uuidString)", in: namespace))
        } label: {
            attendee.profilePhoto
                .resizable()
                .scaledToFit()
                .scaledToFill()
                .clipShape(Circle())
                .matchedTransitionSource(id: "\(attendee.id.uuidString)", in: namespace)
        }
        .contentShape(.contextMenuPreview, .circle)
        .contextMenu {
            ControlGroup {
                if let phone = attendee.phone?.replacingOccurrences(of: " ", with: "") {
                    Button("Call", systemImage: "phone") {
                        openURL(URL(string: "tel:\(phone)")!)
                    }
                    
                    Button("Message", systemImage: "message") {
                        openURL(URL(string: "sms:\(phone)")!)
                    }
                }
                if let email = attendee.email {
                    Button("Email", systemImage: "envelope") {
                        openURL(URL(string: "mailto:\(email)")!)
                    }
                }
            }
            
            Section(attendee.name) {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    showDeleteConfirmation = true
                }
            }
        }
        .alert("Are you sure you want to delete \(attendee.name)?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                modelContext.delete(attendee)
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
