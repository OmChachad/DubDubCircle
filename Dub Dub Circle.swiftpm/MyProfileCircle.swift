//
//  MyProfileCircle.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

import SwiftUI
import SwiftData

struct MyProfileCircle: View {
    @Environment(\.modelContext) var context
    
    @Query(filter: #Predicate<Contact> { profile in
        profile.isMyProfile == true
    }) var profiles: [Contact]
    
    @State private var showingEditor = false
    
    var body: some View {
        Button {
            showingEditor = true
        } label: {
            profiles.first?.profilePhotoCircle
        }
//        .onAppear {
//            if profiles.isEmpty {
//                let newProfile = Contact(isMyProfile: true, name: "Om", notes: "", developmentPlatforms: [.iphone], developmentFrameworks: [.swiftUI])
//                context.insert(newProfile)
//                try? context.save()
//            }
//        }
        .sheet(isPresented: $showingEditor) {
            NewAttendeeView(editing: profiles.first!)
        }
    }
}
