//
//  JournalEntry.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import Foundation

struct JournalEntry: Codable {
    var title: String
    var journalContents: AttributedString
    
    var date: Date
}
