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
        let userInfoManager: UserInfoManagerProtocol
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
            viewModel: makeMyPageViewModel(actions: actions)
        )
    }
    
    private func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return MyPageViewModel(
            signOutUseCase: DefaultSignOutUseCase(
                repository: DefaultAuthenticationRepository(provider: dependencies.provider),
                signoutManager: dependencies.signOutManager),
            actions: actions,
            userInfoManager: dependencies.userInfoManager)
    }
    
    func makeProfileSettingsViewController(actions: ProfileSettingsViewModelActions) -> UIViewController {
        return ProfileSettingsViewController(viewModel: makeProfileSettingsViewModel(actions: actions))
    }
    
    private func makeProfileSettingsViewModel(actions: ProfileSettingsViewModelActions) -> ProfileSettingsViewModel {
        return ProfileSettingsViewModel(
            validateNicknameUseCase: DefaultValidateNicknameUseCase(validator: NickNameValidator()),
            setupProfileInfoUseCase: DefaultSetupProfileInfoUseCase(repository: DefaultProfileSettingsRepository(provider: dependencies.provider)),
            actions: actions,
            userInfoManager: dependencies.userInfoManager)
    }
}
