//
//  NativeModalCountryCoordinator.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

final class NativeModalCountryCoordinator: Coordinator {
    let navigationController: UINavigationController?
    private let viewController: NativeModalCountryVC

  
    init(_ navigationController: UINavigationController?) {
        let repository = CountryRepositoryImpl()
        let useCase = CountryUseCaseImpl(repository: repository)
        let viewModel = CustomModalCountryViewModel(useCase: useCase)
        self.viewController = NativeModalCountryVC(viewModel: viewModel)
        self.navigationController = navigationController
    }

    func start() {
        viewController.isModalInPresentation = true
        viewController.modalPresentationStyle = .pageSheet
        self.navigationController?.present(viewController, animated: true)
    }
}

