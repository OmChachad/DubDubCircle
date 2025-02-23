//
//  NewAttendeeView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/6/25.
//

import SwiftUI
import PhotosUI

struct NewAttendeeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var event: DeveloperEvent?
    
    @State private var profilePhotoData: Data?
    @State var photoPickerItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var notes = ""
    
    @State private var businessCard: BusinessCard?
    
    @State private var developmentPlatforms: Set<Contact.Platform> = []
    @State private var developmentFrameworks: Set<Contact.DevelopmentFramework> = []
    
    init(event: DeveloperEvent) {
        self.event = event
    }
    
    var existingAttendee: Contact?
    
    init(editing existingAttendee: Contact) {
        self.event = nil
        self.existingAttendee = existingAttendee
        
        _profilePhotoData = State(initialValue: existingAttendee.imageData)
        _name = State(initialValue: existingAttendee.name)
        _email = State(initialValue: existingAttendee.email ?? "")
        _phone = State(initialValue: existingAttendee.phone ?? "")
        _notes = State(initialValue: existingAttendee.notes)
        _businessCard = State(initialValue: existingAttendee.businessCard)
        _developmentPlatforms = State(initialValue: Set(existingAttendee.developmentPlatforms))
        _developmentFrameworks = State(initialValue: Set(existingAttendee.developmentFrameworks))
    }

    var body: some View {
        NavigationStack {
            Form {
                Group {
                    if let profilePhotoData {
                        Image(uiImage: UIImage(data: profilePhotoData)!)
                            .resizable()
                             .scaledToFit()
                             .scaledToFill()
                             .frame(width: 150, height: 175)
                             .clipShape(Circle())
                             .glow()
                    } else {
                        Image(systemName: "person.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .offset(x: 5, y: 5)
                            .padding(30)
                            .frame(width: 150, height: 150)
                            .background(Color(.systemGray5), in: .circle)
                    }
                }
                .padding(5)
                .onTapGesture {
                    showPhotoPicker = true
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color(.systemGroupedBackground))
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem)
                .onChange(of: photoPickerItem) {
                    if let photoPickerItem {
                        Task {
                            profilePhotoData = try? await photoPickerItem.loadTransferable(type: Data.self)
                        }
                    }
                }
                
                Section {
                    TextField("Name", text: $name)
                }
                
                Section("Development Experience") {
                    HStack {
                        Text("Platforms")
                        
                        Spacer()
                        
                        ForEach(Contact.Platform.allCases, id: \.self) { platform in
                            Image(systemName: platform.iconName)
                                .symbolEffect(.bounce, value: developmentPlatforms.contains(platform))
                                .imageScale(.large)
                                .foregroundStyle(Color.accentColor)
                                .opacity(developmentPlatforms.contains(platform) ? 1 : 0.3)
                                .onTapGesture {
                                    withAnimation {
                                        if developmentPlatforms.contains(platform) {
                                            developmentPlatforms.remove(platform)
                                        } else {
                                            developmentPlatforms.insert(platform)
                                        }
                                    }
                                }
                        }
                    }
                    
                    HStack {
                        Text("Framework Experience")
                        
                        Spacer()
                        
                        ForEach(Contact.DevelopmentFramework.allCases, id: \.self) { framework in
                            Text(framework.rawValue)
                                .fontWidth(.expanded)
                                .foregroundStyle(Color.accentColor)
                                .opacity(developmentFrameworks.contains(framework) ? 1 : 0.3)
                                .onTapGesture {
                                    withAnimation {
                                        if developmentFrameworks.contains(framework) {
                                            developmentFrameworks.remove(framework)
                                        } else {
                                            developmentFrameworks.insert(framework)
                                        }
                                    }
                                }
                                .padding(.leading, 10)
                        }
                    }
                }
                
                Section("Contact Details") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section("Business Card") {
                    BusinessCardPicker(card: $businessCard)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("\(existingAttendee == nil ? "New Attendee" : "Edit Profile")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let existingAttendee {
                            existingAttendee.imageData = profilePhotoData
                            existingAttendee.name = name
                            existingAttendee.email = email
                            existingAttendee.phone = phone
                            existingAttendee.notes = notes
                            existingAttendee.businessCard = businessCard
                            existingAttendee.developmentPlatforms = [Contact.Platform](developmentPlatforms)
                            existingAttendee.developmentFrameworks = [Contact.DevelopmentFramework](developmentFrameworks)
                        } else {
                            let newAttendee = Contact(imageData: profilePhotoData, name: name, email: email, phone: phone, notes: notes, businessCard: businessCard, events: [], developmentPlatforms: [Contact.Platform](developmentPlatforms), developmentFrameworks: [Contact.DevelopmentFramework](developmentFrameworks))
                            event?.attendees.append(newAttendee)
                        }
                        
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}


#Preview {
    VStack {
        
    }
    .sheet(isPresented: .constant(true)) {
        NewAttendeeView(event: DeveloperEvent(title: "WWDC", date: Date(), wasOnline: true))
    }
}


//Model
//class Contact {
//    var id: UUID
//    @Attribute(.externalStorage) var imageData: Data?
//    var name: String
//    var email: String?
//    var phone: String?
//    var notes: String
//    @Attribute(.externalStorage) var businessCard: BusinessCard?
//    var events: [DeveloperEvent]
//    
//    var profilePhoto: Image {
//        if let data = imageData {
//            if let uiImage = UIImage(data: data) {
//                return Image(uiImage: uiImage)
//            }
//        }
//        
//        return Image(systemName: "person.circle")
//    }
//    
//    init(id: UUID = UUID(), imageData: Data? = nil, name: String, email: String? = nil, phone: String? = nil, notes: String, businessCard: BusinessCard? = nil, events: [DeveloperEvent]) {
//        self.id = id
//        self.imageData = imageData
//        self.name = name
//        self.email = email
//        self.phone = phone
//        self.notes = notes
//        self.businessCard = businessCard
//        self.events = events
//    }
//}
