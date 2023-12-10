//
//  SocialDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import UIKit

final class SocialDIContainer: SocialFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
        let signOutManager: SignOutManagerProtocol
        let userInfoManager: UserInfoManagerProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeSocialFlowCoordinator(navigationController: UINavigationController) -> SocialFlowCoordinator {
        return SocialFlowCoordinator(
            dependencies: self,
            navigationController: navigationController)
    }
    
    func makeSocialViewController(actions: SocialViewModelActions) -> UIViewController {
        return SocialViewController(
            viewModel: SocialViewModel(
                actions: actions,
                socialUseCase: DefaultSocialUseCase(
                    repsoitory: DefaultSocialRepository(
                        provider: dependencies.provider)),
                friendStatusPollingManager: FriendStatusPollingManager(),
                userInfoManager: dependencies.userInfoManager
            )
        )
    }
    
    func makeFriendAddViewController(actions: FriendAddViewModelActions) -> UIViewController {
        return FriendAddViewController(viewModel: FriendAddViewModel(
            friendUseCase: DefaultFriendUseCase(
                repository: DefaultFriendRepository(
                    provider: dependencies.provider)),
            actions: actions,
            userInfoManager: dependencies.userInfoManager)
        )
    }
    
    func makeSocialDetailViewController(actions: SocialDetailViewModelActions, friend: Friend) -> UIViewController {
        return SocialDetailViewController(viewModel: SocialDetailViewModel(friend: friend, friendUseCase: DefaultFriendUseCase(
            repository: DefaultFriendRepository(
                provider: dependencies.provider)), actions: actions)
            )
    }
    
    func makeMyPageDIContainer() -> MyPageDIContainer {
        return MyPageDIContainer(
            dependencies: MyPageDIContainer.Dependencies(
                provider: dependencies.provider,
                signOutManager: dependencies.signOutManager,
                userInfoManager: dependencies.userInfoManager)
        )
    }
}
