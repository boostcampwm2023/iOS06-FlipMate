//
//  TabBarFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

protocol TabBarFlowCoordinatorDependencies {
    func makeTabBarController() -> UITabBarController
    func makeTimerViewController() -> UIViewController
    func makeTimerDIContainer() -> TimerSceneDIContainer
    func makeSocialDIContainer() -> SocialDIContainer
}

final class TabBarFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    private var navigationController: UINavigationController
    private weak var tabBarViewController: UITabBarController?
    private let dependencies: TabBarFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: TabBarFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let tabBarController = dependencies.makeTabBarController()
        tabBarController.setViewControllers(
            [makeSocialViewController(), makeTimerViewContorller(), makeChartViewController()],
            animated: false
        )
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [tabBarController]
        tabBarController.selectedIndex = 1
        tabBarViewController = tabBarController
    }
    
    private func makeTimerViewContorller() -> UINavigationController {
        let navigationViewController = UINavigationController()
        let timerSceneDIContainer = dependencies.makeTimerDIContainer()
        let coordinator = timerSceneDIContainer.makeTimerFlowCoordinator(
            navigationController: navigationViewController)
        coordinator.start()
        return navigationViewController
    }
    
    private func makeSocialViewController() -> UINavigationController {
        let navigationViewController = UINavigationController()
        navigationViewController.tabBarItem.image = UIImage(
            systemName: Constant.socialNomalImageName)
        navigationViewController.tabBarItem.selectedImage = UIImage(
            systemName: Constant.socialSelectedImageName)
        let socialDIContainer = dependencies.makeSocialDIContainer()
        let coordinator = socialDIContainer.makeSocialFlowCoordinator(
            navigationController: navigationViewController)
        coordinator.start()
        return navigationViewController
    }
    
    private func makeChartViewController() -> UINavigationController {
        let navigationViewController = UINavigationController()
        navigationViewController.tabBarItem.image = UIImage(
            systemName: Constant.chartNomalImageName)
        navigationViewController.tabBarItem.selectedImage = UIImage(
            systemName: Constant.chartSelectedImageName)
        return navigationViewController
    }
    
    private enum Constant {
        static let socialNomalImageName = "person.3"
        static let socialSelectedImageName = "person.3.fill"
        static let chartNomalImageName = "chart.bar"
        static let chartSelectedImageName = "chart.bar.fill"
    }
}
