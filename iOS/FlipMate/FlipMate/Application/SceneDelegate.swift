//
//  SceneDelegate.swift
//  FlipMate
//
//  Created by 권승용 on 11/9/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        
        
        let timerViewController = UINavigationController(rootViewController: ViewController())
        let socialViewController = UINavigationController(rootViewController: ViewController())
        let chartViewController = UINavigationController(rootViewController: ViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([timerViewController, socialViewController, chartViewController], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "person.3.fill")
            items[0].image = UIImage(systemName: "person.3")
            
            items[1].selectedImage = UIImage(systemName: "timer")
            items[1].image = UIImage(systemName: "timer")
            
            items[2].selectedImage = UIImage(systemName: "chart.bar.fill")
            items[2].image = UIImage(systemName: "chart.bar")
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
