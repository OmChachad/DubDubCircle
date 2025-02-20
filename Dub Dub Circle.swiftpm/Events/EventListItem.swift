//
//  EventListItem.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/5/25.
//

import SwiftUI

struct EventListItem: View {
    var event: DeveloperEvent
    
    var body: some View {
        HStack {
            
            eventIconCircle()
            
            VStack(alignment: .leading) {
                
                Group {
                    Text(event.title)
                        .font(.headline)
                    //                +
                    Text((event.location?.name ?? "Online"))
                        .opacity(0.6)
                }
                .lineLimit(1)
                
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .opacity(0.6)
                
            }
            
            Spacer()
        }
    }
    
    func eventIconCircle() -> some View {
        ZStack {
            let attendees = event.attendees.prefix(3)
            ForEach(attendees, id: \.self) { attendee in
                let index = attendees.firstIndex(of: attendee)!
                
                attendee.profilePhotoCircle
                    .overlay {
                        Circle()
                            .fill(.clear)
                            .stroke(Color.white, lineWidth: 1)
                    }
                    .frame(width: 30, height: 30)
                    .zIndex(Double(3 - index))
                    .offset(x: CGFloat(index * 10))
            }
            
            if attendees.count < 3 {
                ForEach((attendees.count)..<3, id: \.self) { index in
                    Circle()
                        .fill(Gradient(colors: [.cyan, .purple]))
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: 30, height: 30)
                        .zIndex(Double(3 - index))
                        .offset(x: CGFloat(index * 10))
                }
            }
        }
        .offset(x: -10)
        .frame(width: 50)
        
    }
}

#Preview {
    let event = DeveloperEvent(title: "WWDC", date: Date(), wasOnline: true)
    EventListItem(event: event)
}
