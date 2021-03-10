//
//  AppCoordinator.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let noInternetView = NoNetworkView()
    
    internal var childCoordinators = [Coordinator]()
    private let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()

        self.window.rootViewController = navigationController
    }

    func start() {
        showRating()
        checkNetwork()
    }

    private func showRating() {
        let ratingCoordinator = RatingCoordinator(navigationController: navigationController)
        ratingCoordinator.start()
    }
    
    private func checkNetwork() {
        noInternetView.frame = window.bounds
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if Reachability.isConnectedToNetwork() {
                self?.noInternetView.removeFromSuperview()
            } else {
                guard let noInternetView = self?.noInternetView, noInternetView.superview == nil else { return }
                self?.window.addSubview(noInternetView)
            }
        }
    }
}
