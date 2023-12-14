//
//  TabBarFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/26.
//

import UIKit

protocol TabBarFlowCoordinatorDependencies {
    func makeTabBarController() -> TabBarViewController
    func makeTimerViewController() -> UIViewController
    func makeTimerDIContainer() -> TimerSceneDIContainer
    func makeSocialDIContainer() -> SocialDIContainer
    func makeChartDIContainer() -> ChartDIContainer
}

final class TabBarFlowCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    weak var navigationController: UINavigationController?
    private weak var tabBarViewController: UITabBarController?
    private let dependencies: TabBarFlowCoordinatorDependencies
    private var socialViewController: UINavigationController?
    
    init(navigationController: UINavigationController?, dependencies: TabBarFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let tabBarController = dependencies.makeTabBarController()
        tabBarController.delegate = self
        tabBarController.timeZoneDelegate = self
        tabBarController.setViewControllers(
            [setSocialViewController(), makeTimerViewContorller(), makeChartViewController()],
            animated: false
        )
        tabBarController.tabBar.tintColor = FlipMateColor.tabBarIconSelected.color
        navigationController?.isNavigationBarHidden = true
        navigationController?.viewControllers = [tabBarController]
        tabBarController.selectedIndex = 1
        tabBarViewController = tabBarController
    }
    
    private func makeTimerViewContorller() -> UINavigationController {
        let navigationViewController = UINavigationController()
        let timerSceneDIContainer = dependencies.makeTimerDIContainer()
        let coordinator = timerSceneDIContainer.makeTimerFlowCoordinator(
            navigationController: navigationViewController)
        coordinator.start()
        childCoordinators.append(coordinator)
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
        childCoordinators.append(coordinator)
        return navigationViewController
    }
    
    private func setSocialViewController() -> UINavigationController {
        let navigationViewController = UINavigationController()
        navigationViewController.tabBarItem.image = UIImage(
            systemName: Constant.socialNomalImageName)
        navigationViewController.tabBarItem.selectedImage = UIImage(
            systemName: Constant.socialSelectedImageName)
        return navigationViewController
    }
    
    private func makeChartViewController() -> UINavigationController {
        let navigationViewController = UINavigationController()
        navigationViewController.tabBarItem.image = UIImage(
            systemName: Constant.chartNomalImageName)
        navigationViewController.tabBarItem.selectedImage = UIImage(
            systemName: Constant.chartSelectedImageName)
        let chartDIContainer = dependencies.makeChartDIContainer()
        let coordinator = chartDIContainer.makeChartFlowCoordinator(navigationController: navigationViewController)
        coordinator.start()
        return navigationViewController
    }
    
    private enum Constant {
        static let socialNomalImageName = "person.3"
        static let socialSelectedImageName = "person.3.fill"
        static let chartNomalImageName = "chart.bar"
        static let chartSelectedImageName = "chart.bar.fill"
    }
}

extension TabBarFlowCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let tabBarVC = tabBarController as? TabBarViewController {
            tabBarVC.timerButton.imageView?.tintColor = FlipMateColor.tabBarIconUnSelected.color
        }
        FeedbackManager.shared.startTabBarItemTapFeedback()
        
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            if index == 0 && socialViewController == nil {
                socialViewController = makeSocialViewController()
                guard let socialViewController else { return }
                tabBarController.viewControllers?[index] = socialViewController
            } else {
                return
            }
        }
    }
}

extension TabBarFlowCoordinator: TimeZoneDelegate {
    func didChangeTimeZone() {
        socialViewController = nil
        childCoordinators = []
        start()
    }
}
