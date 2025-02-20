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
            } else {
                attendee.profilePhotoCircle
                    .matchedTransitionSource(id: "\(attendee.id.uuidString)", in: namespace)
                    .matchedGeometryEffect(id: "\(attendee.id.uuidString)", in: namespace)
                
                .contentShape(.contextMenuPreview, .circle)
            }
        }
        .buttonStyle(.plain)
        .attendeeContextMenu(attendee: attendee)
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
