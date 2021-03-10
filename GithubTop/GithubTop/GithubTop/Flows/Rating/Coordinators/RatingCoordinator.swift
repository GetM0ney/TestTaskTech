//
//  RatingCoordinator.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import UIKit

final class RatingCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    internal var childCoordinators = [Coordinator]()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = TopReposViewModel()
        let controller = TopReposViewController(viewModel: viewModel)
        viewModel.delegate = controller
        viewModel.coordinatorDelegate = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension RatingCoordinator: TopReposCoordinatorDelegate {
    func selectLanguage(isFirstLaunch: Bool) {
        let viewModel = LanguageViewModel(isFirstLaunch: isFirstLaunch)
        let controller = LanguageViewController(viewModel: viewModel)
        viewModel.delegate = controller
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showUrl(_ url: URL) {
        let controller = WebViewController(url: url)
        navigationController.pushViewController(controller, animated: true)
    }
}
