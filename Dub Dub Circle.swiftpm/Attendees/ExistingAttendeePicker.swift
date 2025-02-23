//
//  ExistingAttendeePicker.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

import SwiftUI
import SwiftData

struct ExistingAttendeePicker: View {
    @Environment(\.dismiss) var dismiss
    
    @Query(filter: #Predicate<Contact> {
        $0.isMyProfile == false
    }) var attendees: [Contact]
    
    @State var selectedAttendee: Contact? = nil
    
    var event: DeveloperEvent
    
    var result: (Contact) -> Void
    
    var filteredAttendees: [Contact] {
        attendees.filter({ attendee in
            !event.attendees.contains(attendee)
        })
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredAttendees.isEmpty {
                    ContentUnavailableView("No previously added attendees.", systemImage: "person.3.fill")
                } else {
                    Form {
                        Picker("Select Attendees", selection: $selectedAttendee) {
                            ForEach(filteredAttendees, id: \.self) { attendee in
                                HStack {
                                    attendee.profilePhotoCircle
                                        .frame(width: 50, height: 50)
                                        .padding(.trailing, 10)
                                    
                                    Text(attendee.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                }
                                .padding(10)
                                .tag(attendee as Contact?)
                            }
                        }
                        .pickerStyle(.inline)
                    }
                }
            }
            .navigationTitle("Import from existing attendees")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if let selectedAttendee {
                        Button("Done") {
                            dismiss()
                            result(selectedAttendee)
                        }
                    }
                }
            }
        }
    }
}
