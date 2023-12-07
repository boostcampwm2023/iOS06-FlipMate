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
    private var myPageNavigationController: UINavigationController!
    private var dependencies: MyPageFlowCoordinatorDependencies
    
    init(dependencies: MyPageFlowCoordinatorDependencies, navigationController: UINavigationController?) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let actions = MyPageViewModelActions(
            showProfileSettingsView: showProfileSettingsView,
            viewDidFinish: dismissView
            )
        let myPageViewControlelr = dependencies.makeMyPageViewController(actions: actions)
        myPageNavigationController = UINavigationController(rootViewController: myPageViewControlelr)
        myPageNavigationController.modalPresentationStyle = .fullScreen
     
        navigationController?.present(myPageNavigationController, animated: true)
    }
    
    private func dismissView() {
        navigationController?.dismiss(animated: true)
        releaseViewFromMemory()
    }
    private func releaseViewFromMemory() {
        parentCoordinator?.childDidFinish(self)
    }
    
    private func showProfileSettingsView() {
        let actions = ProfileSettingsViewModelActions(
            didFinishSignUp: didFinishSignUp
        )
        let profileSettingsViewControlelr = dependencies.makeProfileSettingsViewController(actions: actions)
        myPageNavigationController.pushViewController(profileSettingsViewControlelr, animated: true)
//        navigationController?.pushViewController(profileSettingsViewControlelr, animated: true)
    }
    
    private func didFinishSignUp() {
        navigationController?.popViewController(animated: true)
    }
}
