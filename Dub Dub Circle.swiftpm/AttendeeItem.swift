//
//  AttendeeItem.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/8/25.
//

import SwiftUI

struct AttendeeItem: View {
    var attendee: Contact
    @Namespace var namespace: Namespace.ID
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
    }
}
