//
//  DashboardRepository.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

protocol DashboardRepository {
    func fetchDashboardItems() async throws -> [DashboardItemModel]
}

final class DashboardRepositoryImpl: DashboardRepository {
    
    private let networkManager: MockNetworkManager
    
    init(networkManager: MockNetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchDashboardItems() async throws -> [DashboardItemModel] {
        return try await networkManager.fetch(DashboardRouter.carousal)
    }
}
