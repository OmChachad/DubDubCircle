//
//  DeveloperEvent.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import Foundation
import MapKit
import SwiftData

@Model
class DeveloperEvent {
    var title: String
    var date: Date
    
    var location: Location?
    var wasOnline: Bool
    
    @Relationship(inverse: \Contact.events) var attendees: [Contact]
    
    @Attribute(.externalStorage) var memories: [Memory]
    @Relationship(inverse: \JournalEntry.event) var journalEntries: [JournalEntry]
    
    init(title: String, attendees: [Contact] = [], memories: [Memory] = [], journalEntries: [JournalEntry] = [], date: Date, location: Location) {
        self.title = title
        self.attendees = attendees
        self.memories = memories
        self.journalEntries = journalEntries
        self.date = date
        self.location = location
        self.wasOnline = false
    }
    
    init(title: String, attendees: [Contact] = [], memories: [Memory] = [], journalEntries: [JournalEntry] = [], date: Date, wasOnline: Bool) {
        self.title = title
        self.attendees = attendees
        self.memories = memories
        self.journalEntries = journalEntries
        self.date = date
        self.wasOnline = wasOnline
    }
}
