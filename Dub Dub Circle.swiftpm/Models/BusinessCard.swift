//
//  File.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import Foundation

struct BusinessCard: Codable {
    var imageData: Data
    var name: String
    var email: String?
    var phone: String?
    var address: String?
    var urls: [URL]
}
