//
//  MemoriesView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/14/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct MemoriesView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var event: DeveloperEvent
    
    @State private var isShowingPhotoPicker = false
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach($event.memories, id: \.self) { $memory in
                        MemoriesItem(memory: $memory) {
                            event.memories.removeAll { $0.id == memory.id }
                            try? modelContext.save()
                        }
                    }
                    .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                        view
                            .blur(radius: phase.isIdentity ? 0 : 5)
                            .opacity(phase.isIdentity ? 1: 0.75)
                            .rotation3DEffect(.degrees(phase.value * 10),
                                              axis: (x: 0, y: -1, z: 0))
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
                }
                .scrollTargetLayout()
            }
            .navigationTitle("Memories")
            .navigationBarTitleDisplayMode(.inline)
            .contentMargins(40, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add Photo", systemImage: "photo.badge.plus.fill") {
                        isShowingPhotoPicker = true
                    }
                    .labelStyle(.iconOnly)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismiss.callAsFunction)
                        .bold()
                }
            }
        }
        .photosPicker(isPresented: $isShowingPhotoPicker, selection: $photoPickerItem, photoLibrary: .shared())
        .onChange(of: photoPickerItem) {
            Task {
                guard let photoPickerItem else { return }
                
                do {
                    let data = try await photoPickerItem.loadTransferable(type: Data.self)
                    guard let data else { return }

                    var memory = Memory(imageData: data)

                    if let id = photoPickerItem.itemIdentifier {
                        let result = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
                        if let asset = result.firstObject, let date = asset.creationDate {
                            memory.date = date
                        }
                    }

                    event.memories.append(memory)
                    try modelContext.save()
                } catch {
                    print("Failed to load photo: \(error)")
                }

                self.photoPickerItem = nil
            }
        }
    }
}
