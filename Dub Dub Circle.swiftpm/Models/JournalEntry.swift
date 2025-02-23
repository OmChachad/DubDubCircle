//
//  JournalEntry.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import Foundation
import SwiftData

@Model
class JournalEntry {
    var event: DeveloperEvent
    
    var title: String
    var contents: JournalContents?
    
    var date: Date
    
    @Relationship var relatedAttendees: [Contact]
    
    init(event: DeveloperEvent, title: String, journalContents: AttributedString = AttributedString(""), date: Date, relatedAttendees: [Contact] = []) {
        self.event = event
        self.title = title
        self.contents = try? JournalContents(journalContents)
        self.date = date
        self.relatedAttendees = relatedAttendees
    }
    
    init(event: DeveloperEvent, title: String, journalContents: NSAttributedString = NSAttributedString(string: ""), date: Date, relatedAttendees: [Contact] = []) {
        self.event = event
        self.title = title
        self.contents = try? JournalContents(journalContents)
        self.date = date
        self.relatedAttendees = relatedAttendees
    }
}
