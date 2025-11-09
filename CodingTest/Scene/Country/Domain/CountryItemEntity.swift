//
//  CountryItemEntity.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//
import UIKit

struct CountryItemEntity {
    let name: String
    let flag: UIImage?
    
    init(name: String, flag: UIImage?) {
        self.name = name
        self.flag = flag
    }
    
    init?(model: CountryItemModel) {
        self.init(name: model.name, flag: UIImage(named: model.imagePath) ?? UIImage(systemName: "flag"))
    }
}
