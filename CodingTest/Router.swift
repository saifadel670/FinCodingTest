//
//  Router.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

protocol Router {
    var urlString: String { get }
    var parameter: [String: Any] { get }
    var headers: [String: Any] { get }
    var method: String { get }
}
