//
//  ListScrollView.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

import Foundation
import SwiftUI
import UIKit

public struct ListScrollView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    public var body: some View {
        List {
            Group {
                content()
                Color.clear.frame(height: 0)
            }
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listSectionSeparatorTint(.clear)
        }
        .listStyle(.plain)
        .environment(\.defaultMinListHeaderHeight, 0)
        .environment(\.defaultMinListRowHeight, 0)
    }
}
