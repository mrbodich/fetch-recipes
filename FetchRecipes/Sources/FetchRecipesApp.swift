//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: delegate.appCoordinator)
                .imageFetcher(delegate.diContainer.imageFetcher)
        }
    }
}
