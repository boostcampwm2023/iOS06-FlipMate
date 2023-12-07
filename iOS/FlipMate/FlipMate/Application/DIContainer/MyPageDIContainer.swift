//
//  MyPageDIContainer.swift
//  FlipMate
//
//  Created by 권승용 on 12/7/23.
//

import UIKit

final class MyPageDIContainer: MyPageFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
        let signOutManager: SignOutManagerProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeMyPageFlowCoordinator(navigationController: UINavigationController?) -> MyPageFlowCoordinator {
        return MyPageFlowCoordinator(
            dependencies: self,
            navigationController: navigationController)
    }
    
    func makeMyPageViewController(actions: MyPageViewModelActions) -> UIViewController {
        return MyPageViewController(
            viewModel: MyPageViewModel(
                authenticationUseCase: DefaultAuthenticationUseCase(
                    repository: DefaultAuthenticationRepository(
                        provider: dependencies.provider),
                    signoutManager: dependencies.signOutManager),
                actions: actions))
    }
    
    func makeProfileSettingsViewController(actions: ProfileSettingsViewModelActions) -> UIViewController {
        let repository = DefaultProfileSettingsRepository(provider: dependencies.provider)
        let useCase = DefaultProfileSettingsUseCase(repository: repository, validator: NickNameValidator())
        let viewModel = ProfileSettingsViewModel(usecase: useCase, actions: actions)
        return ProfileSettingsViewController(viewModel: viewModel)
    }
}
