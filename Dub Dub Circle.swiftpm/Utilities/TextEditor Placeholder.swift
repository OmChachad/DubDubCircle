//
//  TextEditor Placeholder.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/23/25.
//

import Foundation
import SwiftUI

extension View {
    func placeholder(_ text: String, contents: String) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            self
                .padding(EdgeInsets(top: -5, leading: -2, bottom: -7, trailing: -4))
            if contents.isEmpty {
                HStack {
                    Text(text)
                        .foregroundColor(Color(UIColor.placeholderText))
                        .allowsHitTesting(false)
                    Spacer()
                }
            }
        }
        .padding(.top, 7)
    }
}
