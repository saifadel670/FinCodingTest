//
//  CountryUseCase.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import Foundation

protocol CountryUseCase {
    func fetchAllCountries(completion: @escaping ([CountryItemEntity]) -> Void)
}

final class CountryUseCaseImpl: CountryUseCase {
    private let repository: CountryRepository
    
    init(repository: CountryRepository) {
        self.repository = repository
    }
    
    func fetchAllCountries(completion: @escaping ([CountryItemEntity]) -> Void) {
        let models = repository.fetchCountries()
        completion(models.compactMap({CountryItemEntity(model: $0)}))
    }
}
