//
//  SwiftUIView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

import SwiftUI

struct AttendeeCircles: View {
    var attendees: [Contact]
    var maxCount: Int = 3
    var height: CGFloat = 30
    var offset: Int = 10
    var addPlaceholders = true
    
    var body: some View {
        ZStack {
            let attendees = attendees.prefix(maxCount)
            ForEach(attendees, id: \.self) { attendee in
                let index = attendees.firstIndex(of: attendee)!
                
                attendee.profilePhotoCircle
                    .overlay {
                        Circle()
                            .fill(.clear)
                            .stroke(Color.white, lineWidth: 1)
                    }
                    .frame(width: height, height: height)
                    .zIndex(Double(maxCount - index))
                    .offset(x: CGFloat(index * offset))
            }
            
            if attendees.count < maxCount && addPlaceholders == true {
                ForEach((attendees.count)..<maxCount, id: \.self) { index in
                    Circle()
                        .fill(Gradient(colors: [.cyan, .purple]))
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: height, height: height)
                        .zIndex(Double(maxCount - index))
                        .offset(x: CGFloat(index * offset))
                }
            }
        }
        .frame(
            width: height + CGFloat((addPlaceholders ? maxCount : attendees.prefix(maxCount).count) - 1) * CGFloat(offset),
            alignment: .leading
        )
    }
}
