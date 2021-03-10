//
//  Coordinator.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    var childCoordinators: [Coordinator] { get set }
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}
