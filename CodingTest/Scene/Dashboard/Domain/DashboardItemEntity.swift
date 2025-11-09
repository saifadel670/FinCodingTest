//
//  DashboardItemEntity.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

struct DashboardItemEntity {
    let title: String
    let imagePath: String
    
    init (title: String, imagePath: String) {
        self.title = title
        self.imagePath = imagePath
    }
    
    init?(model: DashboardItemModel) {
        self.init(title: model.title, imagePath: model.imagePath)
    }
}
