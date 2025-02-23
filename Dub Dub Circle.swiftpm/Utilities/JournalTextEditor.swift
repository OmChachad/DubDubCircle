//
//  JournalTextEditor.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

// Code derived from the "Enhance your apps with Apple Intelligence and App Intents" Apple developer session I attended in January, in Mumbai. Modified to have a clear background.

import SwiftUI

struct JournalTextEditor: UIViewRepresentable {
    @Binding var text: NSAttributedString
    @Binding var sidePadding: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = JournalTextView()
        textView.isEditable = true
        textView.allowsEditingTextAttributes = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
        sidePadding = uiView.textContainer.lineFragmentPadding
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(textEditor: self)
    }
}

class Coordinator: NSObject, UITextViewDelegate {
    var textEditor: JournalTextEditor
    
    init(textEditor: JournalTextEditor) {
        self.textEditor = textEditor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textEditor.text = textView.attributedText
    }
    
    func textView(_ textView: UITextView, writingToolsIgnoredRangesInEnclosingRange enclosingRange: NSRange) -> [NSValue] {
        guard let journalTextView = textView as? JournalTextView else { return [] }
        return journalTextView.monospacedRanges(in: enclosingRange) as [NSValue]
    }
}

class JournalTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    func monospacedRanges(in enclosingRange: NSRange) -> [NSRange] {
        var ranges: [NSRange] = []
        attributedText.enumerateAttribute(.font, in: enclosingRange) { value, range, _ in
            guard let font = value as? UIFont, font.fontDescriptor.symbolicTraits.contains(.traitMonoSpace) else { return }
            ranges.append(range)
        }
        return ranges
    }
}
