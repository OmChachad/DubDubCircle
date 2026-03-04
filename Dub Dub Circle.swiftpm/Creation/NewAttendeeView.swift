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
    @State private var companyName = ""
    @State private var city = ""
    
    @State private var businessCard: BusinessCard?
    
    @State private var developmentPlatforms: Set<Contact.Platform> = []
    @State private var developmentFrameworks: Set<Contact.DevelopmentFramework> = []
    
    @State private var existingAttendeePicker = false
    
    init(event: DeveloperEvent) {
        self.event = event
    }
    
    var toBeEditedAttendee: Contact?
    
    init(editing toBeEditedAttendee: Contact) {
        self.event = nil
        self.toBeEditedAttendee = toBeEditedAttendee
        
        _profilePhotoData = State(initialValue: toBeEditedAttendee.imageData)
        _name = State(initialValue: toBeEditedAttendee.name)
        _email = State(initialValue: toBeEditedAttendee.email ?? "")
        _phone = State(initialValue: toBeEditedAttendee.phone ?? "")
        _notes = State(initialValue: toBeEditedAttendee.notes)
        _businessCard = State(initialValue: toBeEditedAttendee.businessCard)
        _developmentPlatforms = State(initialValue: Set(toBeEditedAttendee.developmentPlatforms))
        _developmentFrameworks = State(initialValue: Set(toBeEditedAttendee.developmentFrameworks))
        _companyName = State(initialValue: toBeEditedAttendee.companyName ?? "")
        _city = State(initialValue: toBeEditedAttendee.city ?? "")
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
                             .accessibilityLabel("Profile photo")
                             .accessibilityHint("Tap to change photo")
                    } else {
                        Image(systemName: "person.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .offset(x: 5, y: 5)
                            .padding(30)
                            .frame(width: 150, height: 150)
                            .background(Color(.systemGray5), in: .circle)
                            .accessibilityLabel("No profile photo")
                            .accessibilityHint("Tap to add a photo")
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
                .accessibilityAddTraits(.isButton)
                
                Section {
                    TextField("Name", text: $name)
                        .accessibilityLabel("Name field")
                        .accessibilityHint("Enter the person's name")
                }
                
                Section {
                    TextField("Company Name", text: $companyName)
                        .accessibilityLabel("Company name field")
                        .accessibilityHint("Enter the company name")
                }
                
                Section {
                    TextField("City", text: $city)
                        .accessibilityLabel("City field")
                        .accessibilityHint("Enter the city")
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
                                .accessibilityElement()
                                .accessibilityLabel("\(platform.title)")
                                .accessibilityValue(developmentPlatforms.contains(platform) ? "Selected" : "Not selected")
                                .accessibilityHint("Double tap to \(developmentPlatforms.contains(platform) ? "deselect" : "select") \(platform.title)")
                                .accessibilityAddTraits(.isButton)
                        }
                    }
                    .accessibilityElement(children: .contain)
                    
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
                                .accessibilityElement()
                                .accessibilityLabel("\(framework.displayName)")
                                .accessibilityValue(developmentFrameworks.contains(framework) ? "Selected" : "Not selected")
                                .accessibilityHint("Double tap to \(developmentFrameworks.contains(framework) ? "deselect" : "select") \(framework.displayName)")
                                .accessibilityAddTraits(.isButton)
                        }
                    }
                    .accessibilityElement(children: .contain)
                }
                
                Section("Contact Details") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .accessibilityLabel("Email field")
                        .accessibilityHint("Enter email address")
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                        .accessibilityLabel("Phone number field")
                        .accessibilityHint("Enter phone number")
                }
                
                Section {
                    BusinessCardPicker(card: $businessCard)
                } header: {
                    Text("Business Card")
                } footer: {
                    Text("Powered by VisionKit")
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .accessibilityLabel("Notes field")
                        .accessibilityHint("Enter notes about this person")
                }
            }
            .navigationTitle("\(toBeEditedAttendee == nil ? "New Attendee" : "Edit Profile")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Discard changes and close")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if toBeEditedAttendee == nil, let event {
                            Button("Pick Existing", systemImage: "person.crop.circle.badge.plus") {
                                existingAttendeePicker = true
                            }
                            .accessibilityLabel("Pick existing attendee")
                            .accessibilityHint("Select an attendee from your contacts")
                            .sheet(isPresented: $existingAttendeePicker) {
                                ExistingAttendeePicker(event: event) { attendee in
                                    event.attendees.append(attendee)
                                    try? modelContext.save()
                                    existingAttendeePicker = false
                                    dismiss()
                                }
                            }
                        }
                        
                        Button("Save") {
                            if let toBeEditedAttendee {
                                toBeEditedAttendee.imageData = profilePhotoData
                                toBeEditedAttendee.name = name
                                toBeEditedAttendee.email = email
                                toBeEditedAttendee.phone = phone
                                toBeEditedAttendee.notes = notes
                                toBeEditedAttendee.businessCard = businessCard
                                toBeEditedAttendee.developmentPlatforms = [Contact.Platform](developmentPlatforms)
                                toBeEditedAttendee.developmentFrameworks = [Contact.DevelopmentFramework](developmentFrameworks)
                                toBeEditedAttendee.companyName = companyName
                                toBeEditedAttendee.city = city
                            } else {
                                let newAttendee = Contact(imageData: profilePhotoData, name: name, email: email, phone: phone, notes: notes, companyName: companyName, city: city,  businessCard: businessCard, events: [], developmentPlatforms: [Contact.Platform](developmentPlatforms), developmentFrameworks: [Contact.DevelopmentFramework](developmentFrameworks))
                                event?.attendees.append(newAttendee)
                            }
                            
                            try? modelContext.save()
                            dismiss()
                        }
                        .disabled(name.isEmpty)
                        .accessibilityLabel("Save attendee")
                        .accessibilityHint("Save attendee information and close")
                    }
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
