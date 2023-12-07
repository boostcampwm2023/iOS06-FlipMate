//
//  MyPageFlowCoordinator.swift
//  FlipMate
//
//  Created by 권승용 on 12/7/23.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies {
    func makeMyPageFlowCoordinator(navigationController: UINavigationController?) -> MyPageFlowCoordinator
    func makeMyPageViewController(actions: MyPageViewModelActions) -> UIViewController
    func makeProfileSettingsViewController(actions: ProfileSettingsViewModelActions) -> UIViewController
}

final class MyPageFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    private weak var navigationController: UINavigationController?
    private var dependencies: MyPageFlowCoordinatorDependencies
    
    init(dependencies: MyPageFlowCoordinatorDependencies, navigationController: UINavigationController?) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let actions = MyPageViewModelActions(
            showProfileSettingsView: showProfileSettingsView
            )
        let myPageViewControlelr = dependencies.makeMyPageViewController(actions: actions)
        navigationController?.pushViewController(myPageViewControlelr, animated: true)
    }
    
    private func showProfileSettingsView() {
        let actions = ProfileSettingsViewModelActions(
            didFinishSignUp: didFinishSignUp
        )
        let profileSettingsViewControlelr = dependencies.makeProfileSettingsViewController(actions: actions)
        navigationController?.pushViewController(profileSettingsViewControlelr, animated: true)
    }
    
    func didFinishSignUp() {
        navigationController?.popViewController(animated: true)
    }
}
