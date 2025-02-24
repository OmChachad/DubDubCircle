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
                    
                    if let city = attendee.city, !city.isEmpty {
                        Text("\(Image(systemName: "mappin.and.ellipse") ) \(city)")
                            .foregroundColor(.secondary)
                    }
                            
                    
                    ViewThatFits {
                        HStack {
                            developerDetails()
                        }
                        
                        VStack(spacing: 5) {
                            developerDetails()
                        }
                    }
                    .padding(.vertical, 10)
                }
                .padding(.top, 10)
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
//                        .scaledToFill()
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .frame(maxWidth: .infinity, maxHeight: 400, alignment: .center)
                       
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
