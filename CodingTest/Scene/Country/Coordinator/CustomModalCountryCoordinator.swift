//
//  CustomModalCountryCoordinator.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

final class CustomModalCountryCoordinator: Coordinator {
    let navigationController: UINavigationController?
    private let viewController: CustomModalCountryVC

  
    init(_ navigationController: UINavigationController?) {
        let repository = CountryRepositoryImpl()
        let useCase = CountryUseCaseImpl(repository: repository)
        let viewModel = CustomModalCountryViewModel(useCase: useCase)
        self.viewController = CustomModalCountryVC(viewModel: viewModel)
        self.navigationController = navigationController
    }

    func start() {
        viewController.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(viewController, animated: false)
    }
}

