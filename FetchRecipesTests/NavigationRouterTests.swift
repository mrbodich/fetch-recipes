//
//  NavigationRouterTests.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/11/24.
//

import Foundation
import Testing
@testable import FetchRecipes

struct NavigationRouterTests {

    @Test func navigationRouterRouting() async throws {
        // given
        let router = NavigationRouter<Int>()
        
        #expect(router.stack.isEmpty)
        
        router.push(5)
        router.push(6)
        router.push(7)
        
        #expect(router.stack == [5, 6, 7])
        
        router.pop()
        
        #expect(router.stack == [5, 6])
        
        router.popToRootView()
        
        #expect(router.stack.isEmpty)
    }

}
