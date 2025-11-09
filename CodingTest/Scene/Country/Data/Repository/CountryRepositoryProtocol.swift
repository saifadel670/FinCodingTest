//
//  CountryRepositoryProtocol.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import Foundation

protocol CountryRepository {
    func fetchCountries() -> [CountryItemModel]
}

final class CountryRepositoryImpl: CountryRepository {
    func fetchCountries() -> [CountryItemModel] {
        return [
            CountryItemModel(name: "Bangladesh", imagePath: "bd"),
            CountryItemModel(name: "United Kingdom", imagePath: "uk"),
            CountryItemModel(name: "India", imagePath: "india"),
            CountryItemModel(name: "Saudi Arabia", imagePath: "ksa"),
            CountryItemModel(name: "Bangladesh", imagePath: "bd"),
//            CountryItemModel(name: "United Kingdom", imagePath: "uk"),
//            CountryItemModel(name: "India", imagePath: "india"),
//            CountryItemModel(name: "Saudi Arabia", imagePath: "ksa"),
//            CountryItemModel(name: "Bangladesh", imagePath: "bd"),
//            CountryItemModel(name: "United Kingdom", imagePath: "uk"),
//            CountryItemModel(name: "India", imagePath: "india"),
//            CountryItemModel(name: "Saudi Arabia", imagePath: "ksa"),
//            CountryItemModel(name: "Bangladesh", imagePath: "bd"),
//            CountryItemModel(name: "United Kingdom", imagePath: "uk"),
//            CountryItemModel(name: "India", imagePath: "india"),
//            CountryItemModel(name: "Saudi Arabia", imagePath: "ksa"),
//            CountryItemModel(name: "Bangladesh", imagePath: "bd"),
//            CountryItemModel(name: "United Kingdom", imagePath: "uk"),
//            CountryItemModel(name: "India", imagePath: "india"),
//            CountryItemModel(name: "Saudi Arabia", imagePath: "ksa"),
        ]
    }
}

