//
//  JournalContents.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

// Code derived from the "Enhance your apps with Apple Intelligence and App Intents" Apple developer session I attended in January, in Mumbai.

import Foundation
import SwiftData
import UIKit

@Model
final class JournalContents {
    var contentData: Data

    convenience init(_ string: AttributedString) throws {
        var formattedString = string
        formattedString.font = .systemFont(ofSize: UIFont.labelFontSize)
        formattedString.foregroundColor = .label
        let string = NSAttributedString(formattedString)
        try self.init(string)
    }
    
    init(_ string: NSAttributedString) throws {
        contentData = try string.data(
            from: NSRange(location: 0, length: string.length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd]
        )
    }
    
    var asNSAttributedString: NSAttributedString {
        do {
            return try NSAttributedString(data: contentData, documentAttributes: nil)
        } catch {
            return NSAttributedString(string: "")
        }
    }

    var asAttributedString: AttributedString {
        return AttributedString(asNSAttributedString)
    }
}
