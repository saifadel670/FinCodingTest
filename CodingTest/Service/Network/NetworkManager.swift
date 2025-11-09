//
//  NetworkManager.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    func fetch<T: Decodable>(_ router: Router) async throws -> T {
        
        var component: URLComponents? = URLComponents(string: router.urlString)
        var request: URLRequest
        
        switch router.method {
        case "POST":
            guard let url = component?.url else { throw URLError(.badURL)}
            request = URLRequest(url: url)
            request.httpBody = try JSONSerialization.data(withJSONObject: router.parameter, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            break
        default:
            component?.queryItems = router.parameter.map({
                URLQueryItem(name: $0.key, value: "\($0.value)")
            })
            guard let url = component?.url else { throw URLError(.badURL)}
            request = URLRequest(url: url)
            break
        }

        request.httpMethod = router.method
        router.headers.forEach { item in
            request.addValue("\(item.value)", forHTTPHeaderField: item.key)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
