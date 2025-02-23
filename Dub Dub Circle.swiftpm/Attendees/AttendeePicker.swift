//
//  AttendeePicker.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

import SwiftUI
import SwiftData

struct AttendeePicker: View {
    @Environment(\.dismiss) var dismiss
    @Query(filter: #Predicate<Contact> { $0.isMyProfile == false }) var attendees: [Contact]
    @Binding var selectedAttendees: Set<Contact>
    var event: DeveloperEvent
    
    var filteredAttendees: [Contact] {
        attendees.filter { event.attendees.contains($0) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredAttendees, id: \.self, selection: $selectedAttendees) { attendee in
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
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle("Pick Related Attendees")
        }
    }
}
