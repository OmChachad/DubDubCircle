//
//  MemoriesItem.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/16/25.
//

import SwiftUI

struct MemoriesItem: View {
    @Binding var memory: Memory
    
    var deletionAction: () -> (Void)
    
    @State private var isEditingDescription: Bool = false
    @FocusState private var isFocused: Bool
    
    @State private var showDeleteConfirmation: Bool = false
    
    @State private var description: String
    
    @State private var showFullScreenPreview = false
    
    init(memory: Binding<Memory>, deletionAction: @escaping () -> Void) {
        self._memory = memory
        self.deletionAction = deletionAction
        self._description = State(initialValue: memory.wrappedValue.description)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            memory.image
                .resizable()
                .scaledToFit()
                .aspectRatio(3/4, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .overlay(alignment: .topTrailing) {
                    Button {
                        showFullScreenPreview = true
                    } label: {
                        Image(systemName: "arrow.down.left.and.arrow.up.right")
                            .foregroundColor(.white)
                            .font(.title3)
                            .padding(10)
                            .background(.black.opacity(0.7), in: Circle())
                            .padding(10)
                    }
                    .accessibilityLabel("View full screen")
                    .accessibilityHint("Double tap to view this memory in full screen")
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Memory photo\(memory.description.isEmpty ? "" : ": \(memory.description)")")
                .accessibilityAddTraits(.isImage)
            
            Text(memory.date.formatted(date: .abbreviated, time: .shortened))
                .bold()
                .padding(.top, 10)
                .accessibilityLabel("Taken on \(memory.date.formatted(date: .long, time: .shortened))")
            
            HStack {
                if isEditingDescription {
                    Button("Done", action: save)
                        .accessibilityLabel("Done editing")
                        .accessibilityHint("Save description changes")
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                        .onSubmit(save)
                        .accessibilityLabel("Description field")
                        .accessibilityHint("Enter a description for this memory")
                } else {
                    Button("Edit", systemImage: "pencil") {
                        isEditingDescription = true
                    }
                    .labelStyle(.iconOnly)
                    .contentShape(Rectangle())
                    .accessibilityLabel("Edit description")
                    .accessibilityHint("Double tap to edit the photo description")
                    
                    if memory.description.isEmpty {
                        Text("No Description")
                            .foregroundColor(.secondary)
                            .accessibilityLabel("No description")
                    } else {
                        Text(memory.description)
                            .foregroundColor(.secondary)
                            .accessibilityLabel("Description: \(memory.description)")
                    }
                }
            }
            .frame(maxWidth: 350)
            .padding(.top, 5)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack {
                let previewDescription = memory.description.isEmpty ? memory.date.formatted() : memory.description
                ShareLink(item: memory.image, preview: SharePreview(previewDescription, image: memory.image)) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                        .font(.title3)
                        .padding(10)
                        .background(.blue.opacity(0.2), in: Circle())
                }
                .accessibilityLabel("Share memory")
                .accessibilityHint("Double tap to share this photo")
                
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title3)
                        .padding(10)
                        .background(.red.opacity(0.2), in: Circle())
                }
                .accessibilityLabel("Delete memory")
                .accessibilityHint("Double tap to delete this photo")
                .alert("Delete Memory", isPresented: $showDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        withAnimation {
                            deletionAction()
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                    
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this memory? This action is irreversible.")
                }
            }
        }
        .transition(.blurReplace)
        .animation(.default, value: isEditingDescription)
        .onChange(of: isEditingDescription) {
            if isEditingDescription == false {
                save()
            } else {
                isFocused = true
            }
        }
        .fullScreenCover(isPresented: $showFullScreenPreview) {
            NavigationStack {
                memory.image
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Full screen memory photo\(memory.description.isEmpty ? "" : ": \(memory.description)")")
                    .accessibilityAddTraits(.isImage)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                showFullScreenPreview = false
                            }
                            .accessibilityLabel("Close")
                            .accessibilityHint("Exit full screen view")
                        }
                    }
            }
        }
    }
    
    private func save() {
        isEditingDescription = false
        description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        memory.description = description
        isFocused = false
    }
}
