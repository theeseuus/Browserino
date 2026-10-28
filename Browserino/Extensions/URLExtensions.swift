//
//  URLExtensions.swift
//  Browserino
//
//  Created by Claude Code on 05.01.2026.
//

import Foundation

extension URL {
    func matchesHost(_ configuredHost: String) -> Bool {
        if configuredHost.isEmpty {
            return true
        }

        guard let urlHost = self.host()?.lowercased() else { return false }
        let appHost = configuredHost.lowercased()
        return urlHost == appHost || urlHost.hasSuffix("." + appHost)
    }

    func removingTrackingParameters() -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return self
        }

        let filteredQueryItems = queryItems.filter {
            !$0.name.lowercased().hasPrefix("utm_")
        }

        guard filteredQueryItems.count != queryItems.count else {
            return self
        }

        components.queryItems = filteredQueryItems.isEmpty ? nil : filteredQueryItems
        return components.url ?? self
    }
}
