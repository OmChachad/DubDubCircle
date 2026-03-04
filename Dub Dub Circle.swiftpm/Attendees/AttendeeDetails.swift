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
                    attendee.profilePhotoCircle
                        .frame(width: 200, height: 200)
                        .glow()
                        .accessibilityHidden(true)
                    
                        Text(attendee.name)
                            .font(.title)
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                    
                    if let city = attendee.city, !city.isEmpty {
                        Text("\(Image(systemName: "mappin.and.ellipse") ) \(city)")
                            .foregroundColor(.secondary)
                            .accessibilityLabel("Location: \(city)")
                    }
                            
                    
                    ViewThatFits {
                        HStack {
                            developerDetails()
                        }
                        
                        VStack(spacing: 5) {
                            developerDetails()
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
                .padding(.top, 10)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
            .frame(maxWidth: .infinity, alignment: .center)
            
            if !(attendee.companyName ?? "").isEmpty {
                Section("Works at") {
                    Label(attendee.companyName!, systemImage: "suitcase.fill")
                        .accessibilityLabel("Works at \(attendee.companyName!)")
                }
            }
            
            TextEditorSection(title: "Notes", text: $attendeeNotes)
                .onChange(of: attendeeNotes) {
                    attendee.notes = attendeeNotes
                }
                .accessibilityLabel("Notes about \(attendee.name)")
                .accessibilityHint("Edit notes about this person")
            
            
            if !(attendee.phone ?? "").isEmpty || !(attendee.email ?? "").isEmpty {
                Section("Contact") {
                    if let phoneNumber = attendee.phone {
                        LabeledContent("Phone Number", value: phoneNumber)
                            .accessibilityLabel("Phone number: \(phoneNumber)")
                    }
                    
                    if let email = attendee.email {
                        LabeledContent("Email", value: email)
                            .accessibilityLabel("Email: \(email)")
                    }
                }
            }
            
            if let businessCard = attendee.businessCard {
                Section("Business Card") {
                    Image(uiImage: UIImage(data: businessCard.imageData)!)
                        .resizable()
                        .scaledToFit()
//                        .scaledToFill()
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .frame(maxWidth: .infinity, maxHeight: 400, alignment: .center)
                        .accessibilityLabel("Business card image for \(attendee.name)")
                       
                    if let phoneNumber = businessCard.phone {
                        LabeledContent("Phone Number", value: phoneNumber)
                            .accessibilityLabel("Business card phone number: \(phoneNumber)")
                    }
                    
                    if let email = businessCard.email {
                        LabeledContent("Email", value: email)
                            .accessibilityLabel("Business card email: \(email)")
                    }
                    
                    if let address = businessCard.address {
                        LabeledContent("Address", value: address)
                            .accessibilityLabel("Business card address: \(address)")
                    }

                    ForEach(businessCard.urls, id: \.self) { url in
                        LabeledContent("Website", value: url.absoluteString)
                            .accessibilityLabel("Website: \(url.absoluteString)")
                    }
                }
            }
        }
        .contentMargins(Edge.Set(arrayLiteral: .horizontal), 100, for: .scrollContent)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(uiColor: UIColor.systemGroupedBackground))
    }
    
    func developerDetails() -> some View {
        Group {
            if !attendee.developmentPlatforms.isEmpty {
                HStack {
                    Text("Building for")
                    ForEach(attendee.developmentPlatforms, id: \.self) { platform in
                        Image(systemName: platform.iconName)
                            .font(.title2)
                            .fontWeight(.light)
                    }
                }
            }
            
            if !attendee.developmentFrameworks.isEmpty {
                HStack {
                    Text("using")
                    Text(ListFormatter.localizedString(byJoining: attendee.developmentFrameworks.map { $0.displayName }))
                        .bold()
                }
            }
        }
    }
}

#Preview {
    let image = UIImage(named: "Profile")?.pngData()
    AttendeeDetails(attendee: Contact(imageData: image, name: "Om Chachad", notes: "iOS Developer", city: "Mumbai", events: [], developmentPlatforms: [.iphone, .ipad, .vision, .watch, .tv], developmentFrameworks: [.swiftUI, .uiKit, .other]))
}
