//
//  AppDelegate.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    private(set) var diContainer: AppDIContainer!
    private(set) var appCoordinator: AppCoordinator!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let baseUrl: String
        
        do {
            baseUrl = try Config.api.baseAPIUrl
        } catch {
            fatalError("Failed to get base URL: \(error)")
        }
        
        diContainer = .init(baseAPIUrl: baseUrl)
        let screenFabric = ScreenFabricLive(dataService: diContainer.dataService)
        
        appCoordinator = .init(screenFabric: screenFabric)
        
        return true
    }
}
