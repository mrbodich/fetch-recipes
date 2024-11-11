//
//  Logger.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

#if DEBUG
import Foundation

internal struct Logger {
    static func log(_ object: Any) {
        let dateString = dateFormatter.string(from: Date())
        Swift.print("🖻 RemoteImage \(dateString): \(object)")
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss.SSS"
        return formatter
    }()
}
#endif
