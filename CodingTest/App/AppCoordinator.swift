//
//  AppCoordinator.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let dashboardCoordinator = DashboardCoordinator()
        dashboardCoordinator.start()
        window.rootViewController = dashboardCoordinator.navigationController
        window.makeKeyAndVisible()
    }
}
