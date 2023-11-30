//
//  SocialFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import UIKit

protocol SocialFlowCoordinatorDependencies {
    func makeSocialFlowCoordinator(navigationController: UINavigationController) -> SocialFlowCoordinator
    func makeSocialViewController() -> UIViewController
    func makeFriendAddViewControlleR() -> UIViewController
}

final class SocialFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    private var dependencies: SocialFlowCoordinatorDependencies
    
    init(dependencies: SocialFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let socialViewController = dependencies.makeSocialViewController()
        navigationController.viewControllers = [socialViewController]
    }
    
    private func showFreindAddViewController() {
        let freindAddViewContorller = dependencies.makeFriendAddViewControlleR()
        navigationController.pushViewController(freindAddViewContorller, animated: true)
    }
}
