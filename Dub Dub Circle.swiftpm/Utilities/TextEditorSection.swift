//
//  TextEditorSection.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/8/25.
//

import SwiftUI

struct TextEditorSection: View {
    var title: String
    @Binding var text: String
    @State private var textInMemory = ""
    
    @State private var isEdting = false
    
    @FocusState var textEditorIsFocused: Bool
    
    init(title: String, text: Binding<String>) {
        self.title = title
        self._text = text
        self._textInMemory = State(initialValue: text.wrappedValue)
    }
    
    var body: some View {
        Section {
            if isEdting {
                TextEditor(text: $textInMemory)
                    .frame(height: 200)
                    .transition(.blurReplace)
                    .focused($textEditorIsFocused)
            } else {
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("No notes...")
                        .italic()
                } else {
                    Text(text)
                        .transition(.blurReplace)
                }
            }
        } header: {
            HStack {
                Text(title)
                
                Spacer()
                
                if isEdting {
                    Button("Done", systemImage: "checkmark") {
                        withAnimation {
                            isEdting.toggle()
                        }
                    }
                } else {
                    Button("Edit", systemImage: "pencil") {
                        withAnimation {
                            isEdting.toggle()
                        }
                    }
                }
            }
            .font(.footnote)
        }
        .animation(.default, value: isEdting)
        .onChange(of: isEdting) {
            if isEdting == false {
                save()
            } else {
                textEditorIsFocused = true
            }
        }
    }
    
    private func save() {
        isEdting = false
        text = textInMemory
    }
}
