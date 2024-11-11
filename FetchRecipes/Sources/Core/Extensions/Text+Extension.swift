//
//  Text+Extension.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

import SwiftUI

/// Preventing text from Text views to be scanned and placed into the Strings Catalog
extension SwiftUI.Text {
    public init(_ content: String) {
        self.init(verbatim: content)
    }
    
    public init<S>(_ content: S) where S : StringProtocol {
        self.init(verbatim: String(content))
    }
}
