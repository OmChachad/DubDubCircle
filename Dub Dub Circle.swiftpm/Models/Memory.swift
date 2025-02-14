//
//  Memory.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import Foundation
import SwiftUI

struct Memory: Codable, Hashable {
    var id: UUID = UUID()
    var imageData: Data
    var date: Date = .now
    var description: String = ""
    
    var image: Image {
        return Image(uiImage: UIImage(data: imageData)!)
    }
}
