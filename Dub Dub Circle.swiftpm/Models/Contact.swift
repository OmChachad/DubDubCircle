//
//  Contact.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import SwiftData
import SwiftUI

@Model
class Contact {
    var id: UUID
    @Attribute(.externalStorage) var imageData: Data?
    var name: String
    var email: String?
    var phone: String?
    var notes: String
    @Attribute(.externalStorage) var businessCard: BusinessCard?
    var events: [DeveloperEvent]
    
    init(id: UUID = UUID(), imageData: Data? = nil, name: String, email: String? = nil, phone: String? = nil, notes: String, businessCard: BusinessCard? = nil, events: [DeveloperEvent]) {
        self.id = id
        self.imageData = imageData
        self.name = name
        self.email = email
        self.phone = phone
        self.notes = notes
        self.businessCard = businessCard
        self.events = events
    }
}
