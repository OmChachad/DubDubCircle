//
//  AttendeeContextMenu.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/17/25.
//

import SwiftUI

struct AttendeeContextMenu: ViewModifier {
    var attendee: Contact
    
    @Environment(\.openURL) var openURL
    @Environment(\.modelContext) var modelContext
    
    @State private var showDeleteConfirmation = false
    
    func body(content: Content) -> some View {
        content
        
            .contextMenu {
                ControlGroup {
                    let phone = [attendee.phone?.replacingOccurrences(of: " ", with: ""), attendee.businessCard?.phone]
                        .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? $0 : nil }
                        .first

                    if let phone, let callURL = URL(string: "tel:\(phone)"), let smsURL = URL(string: "sms:\(phone)") {
                        Button("Call", systemImage: "phone") {
                            openURL(callURL)
                        }
                        Button("Message", systemImage: "message") {
                            openURL(smsURL)
                        }
                    }

                    let email = [attendee.email, attendee.businessCard?.email]
                        .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? $0 : nil }
                        .first

                    if let email, let mailURL = URL(string: "mailto:\(email)") {
                        Button("Email", systemImage: "envelope") {
                            openURL(mailURL)
                        }
                    }
                }
                
                Section(attendee.name) {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button("Delete", systemImage: "trash") {
                    showDeleteConfirmation = true
                }
                .tint(.red)
            }
            .alert("Are you sure you want to delete \(attendee.name)?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        modelContext.delete(attendee)
                        try? modelContext.save()
                    }
                }
            } message: {
                Text("This action cannot be undone.")
            }
    }
    
}

extension View {
    func attendeeContextMenu(attendee: Contact) -> some View {
        self.modifier(AttendeeContextMenu(attendee: attendee))
    }
}
