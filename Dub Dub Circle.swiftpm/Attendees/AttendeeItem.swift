//
//  AttendeeItem.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/8/25.
//

import SwiftUI

struct AttendeeItem: View {
    @Environment(\.modelContext) var modelContext
    
    var attendee: Contact
    var namespace: Namespace.ID
    
    @State private var showDeleteConfirmation = false
    
    enum ViewStyle {
        case list, circular
    }
    
    var viewStyle: ViewStyle = .circular
    
    var body: some View {
        NavigationLink {
            AttendeeDetails(attendee: attendee)
                .navigationTransition(.zoom(sourceID: "\(attendee.id.uuidString)", in: namespace))
        } label: {
            if viewStyle == .list {
                HStack {
                    attendee.profilePhotoCircle
                        .matchedTransitionSource(id: "\(attendee.id.uuidString)", in: namespace)
                        .matchedGeometryEffect(id: "\(attendee.id.uuidString)", in: namespace)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 10)
                        .accessibilityHidden(true)
                    
                    VStack(alignment: .leading) {
                        Text(attendee.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        developerDetails()
                            .frame(height: 20)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(10)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(attendeeAccessibilityLabel)
                .accessibilityHint("Double tap to view details about \(attendee.name)")
            } else {
                attendee.profilePhotoCircle
                    .matchedTransitionSource(id: "\(attendee.id.uuidString)", in: namespace)
                    .matchedGeometryEffect(id: "\(attendee.id.uuidString)", in: namespace)
                
                .contentShape(.contextMenuPreview, .circle)
                .accessibilityLabel(attendeeAccessibilityLabel)
                .accessibilityHint("Double tap to view details, or hold for quick actions")
                .accessibilityAddTraits(.isButton)
            }
        }
        .buttonStyle(.plain)
        .attendeeContextMenu(attendee: attendee)
    }
    
    var attendeeAccessibilityLabel: String {
        var label = attendee.name
        
        if !attendee.developmentPlatforms.isEmpty {
            let platforms = attendee.developmentPlatforms.map { $0.title }.joined(separator: ", ")
            label += ", develops for \(platforms)"
        }
        
        if !attendee.developmentFrameworks.isEmpty {
            let frameworks = attendee.developmentFrameworks.map { $0.displayName }.joined(separator: ", ")
            label += ", using \(frameworks)"
        }
        
        if let city = attendee.city, !city.isEmpty {
            label += ", from \(city)"
        }
        
        return label
    }
    
    func developerDetails() -> some View {
        HStack {
            if !attendee.developmentPlatforms.isEmpty {
                HStack {
                    Text("Building for")
                    ForEach(attendee.developmentPlatforms, id: \.self) { platform in
                        Image(systemName: platform.iconName)
                            .font(.title3)
                            .fontWeight(.light)
                            .accessibilityLabel(platform.title)
                    }
                }
            }
            
            if !attendee.developmentFrameworks.isEmpty {
                HStack {
                    Text("using")
                    Text(ListFormatter.localizedString(byJoining: attendee.developmentFrameworks.map { $0.displayName }))
                        .bold()
                }
            }
        }
    }
}
