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
                }
            
            Text(memory.date.formatted(date: .abbreviated, time: .shortened))
                .bold()
                .padding(.top, 10)
            
            HStack {
                if isEditingDescription {
                    Button("Done", action: save)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                        .onSubmit(save)
                } else {
                    Button("Edit", systemImage: "pencil") {
                        isEditingDescription = true
                    }
                    .labelStyle(.iconOnly)
                    .contentShape(Rectangle())
                    
                    if memory.description.isEmpty {
                        Text("No Description")
                            .foregroundColor(.secondary)
                    } else {
                        Text(memory.description)
                            .foregroundColor(.secondary)
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
                
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title3)
                        .padding(10)
                        .background(.red.opacity(0.2), in: Circle())
                }
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
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                showFullScreenPreview = false
                            }
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
