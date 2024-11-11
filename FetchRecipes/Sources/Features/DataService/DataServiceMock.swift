//
//  DataServiceMock.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation

#if DEBUG
struct DataServiceMock {
    private var responseDelay: UInt64 //Simulated delay per each request in seconds
    private let mockData: MockData
    
    init(
        delay: Float,
        mockData: MockData = .init()
    ) {
        responseDelay = UInt64(delay * 1_000_000_000) //Convert seconds to nanoseconds
        self.mockData = mockData
    }
}

extension DataServiceMock: DataService {
    func getRecipes() async throws -> [Recipe] {
        try await delay(mockData.recipes)
    }
}

extension DataServiceMock {
    private func delay<T>(_ data: T) async throws -> T {
        try await Task.sleep(nanoseconds: responseDelay)
        return data
    }
}
#endif
