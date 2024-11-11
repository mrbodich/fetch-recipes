//
//  AppDIContainer.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import RemoteImage

final class AppDIContainer {
    let dataService: DataService
    let imageFetcher: ImageFetcher
    
    init(baseAPIUrl: String) {
        dataService = DataServiceLive(baseAPIUrl: baseAPIUrl)
        imageFetcher = RemoteImageFetcher(
            sid: "com.FetchRecipes.remoteImageFetcher",
            memoryCacheCapacity: 150,
            diskCacheCapacity: 100,
            imageBuilderFabric: ResizingImageBuilderFabric()
        )
    }
}
