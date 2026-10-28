//
//  View+ScrollClipDisabled.swift
//  Browserino
//
//  Created by Aleksandr Strizhnev on 03.09.2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func scrollEdgeEffectDisabledCompat() -> some View {
        if #available(macOS 26.0, *) {
            self
                .scrollEdgeEffectHidden(true, for: .all)
        } else {
            self
        }
    }
}
