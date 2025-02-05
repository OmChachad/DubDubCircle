//
//  File.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/4/25.
//

import Foundation
import SwiftUI

extension View {
    func glow() -> some View {
        self
            .background(self.opacity(0.75).blur(radius: 5).allowsHitTesting(false))
    }
}
