//
//  AttendeeDetails.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/7/25.
//

import SwiftUI

struct AttendeeDetails: View {
    var attendee: Contact
    @State private var attendeeNotes: String
    
    init(attendee: Contact) {
        self.attendee = attendee
        self._attendeeNotes = State(initialValue: attendee.notes)
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    attendee.profilePhoto
                        .resizable()
                        .scaledToFit()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .accessibilityHidden(true)
                    
                        Text(attendee.name)
                            .font(.title)
                            .bold()
                        Text("First met on \(attendee.events.first?.date.formatted() ?? "Unknown Event")")
                            .foregroundColor(.secondary)
                }
                .padding()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            if !(attendee.phone ?? "").isEmpty || !(attendee.email ?? "").isEmpty {
                Section("Contact") {
                    if let phoneNumber = attendee.phone {
                        LabeledContent("Phone Number", value: phoneNumber)
                    }
                    
                    if let email = attendee.email {
                        LabeledContent("Email", value: email)
                    }
                }
            }
            
            if let businessCard = attendee.businessCard {
                Section("Business Card") {
                    Image(uiImage: UIImage(data: businessCard.imageData)!)
                        .resizable()
                        .scaledToFit()
                        .scaledToFill()
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                       
                    if let phoneNumber = businessCard.phone {
                        LabeledContent("Phone Number", value: phoneNumber)
                    }
                    
                    if let email = businessCard.email {
                        LabeledContent("Email", value: email)
                    }
                    
                    if let address = businessCard.address {
                        LabeledContent("Address", value: address)
                    }

                    ForEach(businessCard.urls, id: \.self) { url in
                        LabeledContent("Website", value: url.absoluteString)
                    }
                }
            }
            
            TextEditorSection(title: "Notes", text: $attendeeNotes)
                .onChange(of: attendeeNotes) {
                    attendee.notes = attendeeNotes
                }
        }
    }
}

#Preview {
    let image = UIImage(named: "Profile")?.pngData()
    AttendeeDetails(attendee: Contact(imageData: image, name: "Om Chachad", notes: "iOS Developer", events: []))
}
