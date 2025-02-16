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
                    #warning("Clean this up")
                    if let phone = attendee.phone?.replacingOccurrences(of: " ", with: ""), !phone.isEmpty {
                        Button("Call", systemImage: "phone") {
                            openURL(URL(string: "tel:\(phone)")!)
                        }
                        
                        Button("Message", systemImage: "message") {
                            openURL(URL(string: "sms:\(phone)")!)
                        }
                    } else if let phone = attendee.businessCard?.phone {
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
                    } else if let email = attendee.businessCard?.email {
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

extension View {
    func attendeeContextMenu(attendee: Contact) -> some View {
        self.modifier(AttendeeContextMenu(attendee: attendee))
    }
}
