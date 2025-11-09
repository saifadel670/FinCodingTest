//
//  DashboardRouter.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

enum DashboardRouter: Router {
    case carousal
    
    var mockResponse: String {
            """
            [
                {"title": "Item No1", "imagePath": "Image_1"},
                {"title": "Item No2", "imagePath": "Image_2"},
                {"title": "Item No3", "imagePath": "Image_3"},
                {"title": "Item No1", "imagePath": "Image_1"},
                {"title": "Item No2", "imagePath": "Image_2"},
                {"title": "Item No3", "imagePath": "Image_3"},
                {"title": "Item No1", "imagePath": "Image_1"},
                {"title": "Item No2", "imagePath": "Image_2"},
                {"title": "Item No3", "imagePath": "Image_3"},
                {"title": "Item No1", "imagePath": "Image_1"},
                {"title": "Item No2", "imagePath": "Image_2"},
                {"title": "Item No3", "imagePath": "Image_3"},
                {"title": "Item No1", "imagePath": "Image_1"},
                {"title": "Item No2", "imagePath": "Image_2"},
                {"title": "Item No3", "imagePath": "Image_3"},
                {"title": "Item No1", "imagePath": "Image_1"},
                {"title": "Item No2", "imagePath": "Image_2"},
                {"title": "Item No3", "imagePath": "Image_3"},
                {"title": "Item No1", "imagePath": "Image_1"},
                {"title": "Item No2", "imagePath": "Image_2"},
                {"title": "Item No3", "imagePath": "Image_3"}
            ]
            """
    }
}
