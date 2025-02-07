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
    
    var event: DeveloperEvent
    
    @State private var profilePhotoData: Data?
    @State var photoPickerItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var notes = ""
    
    @State private var businessCard: BusinessCard?

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
                .padding(10)
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
                
                Section("Contact Details") {
                    BusinessCardPicker(card: $businessCard)
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Attendee")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newAttendee = Contact(imageData: profilePhotoData, name: name, email: email, phone: phone, notes: notes, businessCard: businessCard, events: [event])
                        modelContext.insert(newAttendee)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

struct BusinessCardPicker: View {
    @Binding var card: BusinessCard?
    
    @State private var imageData: Data?
    @State private var name: String?
    @State private var email: String?
    @State private var phone: String?
    @State private var address: String?
    @State private var urls: [URL] = []
    
    @State private var profilePhotoData: Data?
    @State var photoPickerItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false
    
    var body: some View {
        Section {
            if let imageData {
                
            } else {
                Button {
                    showPhotoPicker = true
                } label: {
                    Label("Add Business Card", systemImage: "plus")
                }
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem)
        .onChange(of: photoPickerItem) {
            if let photoPickerItem {
                Task {
                    profilePhotoData = try? await photoPickerItem.loadTransferable(type: Data.self)
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
