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
    var companyName: String?
    var city: String?
    @Attribute(.externalStorage) var businessCard: BusinessCard?
    var isMyProfile = false
    var events: [DeveloperEvent]
    var developmentPlatforms: [Platform]
    var developmentFrameworks: [DevelopmentFramework]
    
    @ViewBuilder
    var profilePhotoCircle: some View {
        if let imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .scaledToFill()
                .clipShape(Circle())
        } else {
            GeometryReader { geo in
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .scaledToFill()
                    .padding(geo.size.width * 0.3)
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(Circle())
                    .foregroundStyle(Color(uiColor: .systemGray2))
            }
        }
    }
    
    enum Platform: String, Codable, CaseIterable {
        case iphone, ipad, mac, watch, tv, vision
        
        var title: String {
            switch(self) {
            case .iphone:
                return "iPhone"
            case .ipad:
                return "iPad"
            case .mac:
                return "Mac"
            case .watch:
                return "Watch"
            case .tv:
                return "TV"
            case .vision:
                return "Vision"
            }
        }
        
        var iconName: String {
            switch(self) {
            case .iphone:
                return "iphone.gen2"
            case .ipad:
                return "ipad.landscape"
            case .mac:
                return "desktopcomputer"
            case .watch:
                return "applewatch"
            case .tv:
                return "appletv"
            case .vision:
                return "vision.pro"
            }
        }
    }
    
    enum DevelopmentFramework: String, Codable, CaseIterable {
        case swiftUI = "SwiftUI"
        case uiKit = "UIKit"
        case other = "Other"
        
        var displayName: String {
                switch self {
                case .other:
                    return "Other Frameworks"
                default:
                    return rawValue
                }
            }
    }
    
    init(id: UUID = UUID(), imageData: Data? = nil, name: String, email: String? = nil, phone: String? = nil, notes: String, companyName: String? = nil, city: String? = nil, businessCard: BusinessCard? = nil, events: [DeveloperEvent], developmentPlatforms: [Platform], developmentFrameworks: [DevelopmentFramework]) {
        self.id = id
        self.imageData = imageData
        self.name = name
        self.email = email
        self.phone = phone
        self.notes = notes
        self.companyName = companyName
        self.isMyProfile = false
        self.city = city
        self.businessCard = businessCard
        self.events = events
        self.developmentPlatforms = developmentPlatforms
        self.developmentFrameworks = developmentFrameworks
    }
    
    init(id: UUID = UUID(), isMyProfile: Bool, imageData: Data? = nil, name: String, email: String? = nil, phone: String? = nil, notes: String, companyName: String? = nil, city: String? = nil, businessCard: BusinessCard? = nil, developmentPlatforms: [Platform], developmentFrameworks: [DevelopmentFramework]) {
        self.id = id
        self.imageData = imageData
        self.name = name
        self.email = email
        self.phone = phone
        self.notes = notes
        self.companyName = companyName
        self.isMyProfile = isMyProfile
        self.city = city
        self.businessCard = businessCard
        self.events = []
        self.developmentPlatforms = developmentPlatforms
        self.developmentFrameworks = developmentFrameworks
    }

}
