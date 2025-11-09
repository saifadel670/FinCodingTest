//
//  DashboardItemsUseCase.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

protocol DashboardItemsUseCase {
    func execute(completion: @escaping ([DashboardItemEntity]) -> Void)
}

final class DashboardItemsUseCaseImpl: DashboardItemsUseCase {
    private let repository: DashboardRepository
    
    init(repository: DashboardRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping ([DashboardItemEntity]) -> Void) {
        Task {
            do {
                let models = try await repository.fetchDashboardItems()
                completion(models.compactMap({DashboardItemEntity(model: $0)}))
            } catch {
                print("Error fetching dashboard items:", error)
                completion([])
            }
        }
    }
}
