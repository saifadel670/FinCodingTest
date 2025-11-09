//
//  CustomModalCountryViewModel.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

final class CustomModalCountryViewModel {
    
    private let fetchUseCase: CountryUseCase
    var allCountries: [CountryItemEntity]
    var filteredCountries: [CountryItemEntity]
    var onUpdate: (() -> Void)?
    
    init(useCase: CountryUseCase) {
        self.allCountries = []
        self.filteredCountries = []
        self.fetchUseCase = useCase
    }
    
    func loadCountries() {
        fetchUseCase.fetchAllCountries { [weak self] item in
            self?.allCountries = item
            self?.filteredCountries = item
            self?.onUpdate?()
        }
    }
    
    func search(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            filteredCountries = allCountries
            onUpdate?()
            return
        }
        filteredCountries = allCountries.filter { $0.name.lowercased().contains(text.lowercased()) }
        onUpdate?()
    }
    
    func clearSearch() {
        filteredCountries = allCountries
        onUpdate?()
    }
    
    func numberOfRows() -> Int { filteredCountries.count }
    func country(at index: Int) -> CountryItemEntity { filteredCountries[index] }
}
