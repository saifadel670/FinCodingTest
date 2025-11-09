//
//  MockNetworkManager.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

final class MockNetworkManager {
    
    static let shared = MockNetworkManager()
    private init() { }
    
    func fetch<T: Decodable>(_ router: Router) async throws -> T {
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000) // 3 seconds
        guard let data = router.mockResponse.data(using: .utf8) else {
            throw NSError(domain: "MockNetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid mock response"])
        }
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}

