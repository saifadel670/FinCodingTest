//
//  DashboardCoordinator.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import UIKit

final class DashboardCoordinator: Coordinator {
    let navigationController: UINavigationController

    init() {
        let repository = DashboardRepositoryImpl()
        let useCase = DashboardItemsUseCaseImpl(repository: repository)
        let viewModel = DashboardViewModel(useCase: useCase)
        let viewController = DashboardVC(viewModel: viewModel)
        self.navigationController = UINavigationController(rootViewController: viewController)
        viewModel.coordinator = self
    }

    func start() {
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}

extension DashboardCoordinator {
    public func presentCountryModal(_ option: OptionType) {
        switch option {
        case .native:
            let coordinator = NativeModalCountryCoordinator(self.navigationController)
            coordinator.start()
            
        case .custom:
            let coordinator = CustomModalCountryCoordinator(self.navigationController)
            coordinator.start()
        }
        
    }
}
