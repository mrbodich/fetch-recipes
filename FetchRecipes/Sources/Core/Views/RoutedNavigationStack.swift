//
//  RoutedNavigationStack.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

import SwiftUI

struct RoutedNavigationStack<Route: Hashable, Content: View>: View {
    @ObservedObject var router: NavigationRouter<Route>
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        NavigationStack(path: $router.stack, root: content)
    }
}
