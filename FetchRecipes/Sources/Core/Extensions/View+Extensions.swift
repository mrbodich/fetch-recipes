//
//  View+Extensions.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import SwiftUI
import RemoteImage

extension View {
    #if DEBUG
    func mockImageFetcher(delay: Float = 0) -> some View {
        environment(\.imageFetcher, MockImageFetcher(delay: delay))
    }
    #endif
    
    
    func buttonWrapped(action: (() -> ())?) -> some View {
        self.buttonWrapped(style: SimpleButtonStyle(), action: action)
    }
    
    @ViewBuilder
    func buttonWrapped<S: ButtonStyle>(style: S, action: (() -> ())?) -> some View {
        if let action {
            Button(action: action) { self.compositingGroup() }
                .buttonStyle(style)
        } else { self }
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
