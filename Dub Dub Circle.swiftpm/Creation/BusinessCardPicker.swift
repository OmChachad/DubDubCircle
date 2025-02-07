//
//  BusinessCardPicker.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/7/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct BusinessCardPicker: View {
    @Binding var card: BusinessCard?
    
    @State private var imageData: Data?
    @State private var name: String?
    @State private var email: String?
    @State private var phone: String?
    @State private var address: String?
    @State private var urls: [URL] = []
    
    @State private var profilePhotoData: Data?
    @State var photoPickerItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false
    
    var body: some View {
        Section {
            if let imageData {
                
            } else {
                Button {
                    showPhotoPicker = true
                } label: {
                    Label("Add Business Card", systemImage: "plus")
                }
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem)
        .onChange(of: photoPickerItem) {
            if let photoPickerItem {
                Task {
                    profilePhotoData = try? await photoPickerItem.loadTransferable(type: Data.self)
                }
            }
        }
    }
}
 
