//
//  AppDelegate.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()

        window?.makeKeyAndVisible()

        return true
    }
}
