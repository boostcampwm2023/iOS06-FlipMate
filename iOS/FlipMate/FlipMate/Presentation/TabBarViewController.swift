//
//  TabBarViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/13/23.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
}

extension TabBarViewController {
    func configUI() {
        let timerViewController = ViewController() // -> TimerViewController()
        let socialViewController = ViewController()
        let chartViewController = ViewController()
        
        timerViewController.tabBarItem.image = UIImage(systemName: "timer")

        socialViewController.tabBarItem.image = UIImage(systemName: "person.3")
        socialViewController.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")

        chartViewController.tabBarItem.image = UIImage(systemName: "chart.bar")
        chartViewController.tabBarItem.selectedImage = UIImage(systemName: "chart.bar.fill")
        
        let navigationTimer = UINavigationController(rootViewController: timerViewController)
        let navigationSocial = UINavigationController(rootViewController: socialViewController)
        let navigationChart = UINavigationController(rootViewController: chartViewController)
        
        setViewControllers([navigationSocial, navigationTimer, navigationChart], animated: false)
    }
}
