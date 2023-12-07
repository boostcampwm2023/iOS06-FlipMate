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
    func makeSocialViewController(actions: SocialViewModelActions) -> UIViewController
    func makeFriendAddViewController(actions: FriendAddViewModelActions) -> UIViewController
    func makeSocialDetailViewController(actions: SocialDetailViewModelActions, friend: Friend) -> UIViewController
    func makeMyPageDIContainer() -> MyPageDIContainer
}

final class SocialFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private weak var navigationController: UINavigationController?
    private var dependencies: SocialFlowCoordinatorDependencies
    
    init(dependencies: SocialFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let actions = SocialViewModelActions(
            showFriendAddViewController: showFreindAddViewController,
            showSocialDetailViewController: showSocialDetailViewController,
            showMyPageViewController: showMyPageViewController)
        let socialViewController = dependencies.makeSocialViewController(actions: actions)
        navigationController?.viewControllers = [socialViewController]
    }
    
    private func showFreindAddViewController() {
        let actions = FriendAddViewModelActions(
            didCancleFriendAdd: dismissNavigationController,
            didSuccessFriendAdd: dismissNavigationController)
        let freindAddViewContorller = dependencies.makeFriendAddViewController(actions: actions)
        let firendNavigationController = UINavigationController(rootViewController: freindAddViewContorller)
        firendNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.present(firendNavigationController, animated: true)
    }
    
    private func dismissNavigationController() {
        navigationController?.dismiss(animated: true)
    }
    
    func showSocialDetailViewController(friend: Friend) {
        let actions = SocialDetailViewModelActions(
            didCancelSocialDetail: dismissNavigationController,
            didFinishUnfollow: dismissNavigationController)
        let socialDetailViewController = dependencies.makeSocialDetailViewController(actions: actions, friend: friend)
        let socialDetailNavigationController = UINavigationController(rootViewController: socialDetailViewController)
        socialDetailNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.present(socialDetailNavigationController, animated: true)
    }
    
    func showMyPageViewController() {
        let container = dependencies.makeMyPageDIContainer()
        let coordinator = container.makeMyPageFlowCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func didFinishUnfollow() {
        navigationController?.popViewController(animated: true)
    }
}
