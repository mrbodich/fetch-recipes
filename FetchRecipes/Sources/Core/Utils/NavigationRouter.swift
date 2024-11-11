//
//  NavigationRouter.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation

final class NavigationRouter<Route>: ObservableObject {
    @Published var stack: [Route] = []
    
    func push(_ view: Route) {
        stack.append(view)
    }
    
    func pop() {
        stack.removeLast()
    }
    
    func popToRootView() {
        stack.removeAll()
    }
}
