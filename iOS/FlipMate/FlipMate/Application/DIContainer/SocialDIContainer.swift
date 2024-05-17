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
        let userInfoManager: UserInfoManageable
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
        return SocialViewController(viewModel: makeSocialViewModel(actions: actions))
    }
    
    private func makeSocialViewModel(actions: SocialViewModelActions) -> SocialViewModel {
        let repository = DefaultSocialRepository(provider: dependencies.provider)
        return SocialViewModel(
            actions: actions,
            getFriendsUseCase: DefaultGetFriendsUseCase(repsoitory: repository),
            fetchFriendsUseCase: DefaultFetchFriendsUseCase(repsoitory: repository),
            friendStatusPollingManager: FriendStatusPollingManager(timerManager: TimerManager()),
            userInfoManager: dependencies.userInfoManager,
            timerManager: TimerManager(timeInterval: .seconds(4)))
    }
    
    func makeFriendAddViewController(actions: FriendAddViewModelActions) -> UIViewController {
        return FriendAddViewController(viewModel: makeFriendAddViewModel(actions: actions))
    }
    
    private func makeFriendAddViewModel(actions: FriendAddViewModelActions) -> FriendAddViewModel {
        let repository = DefaultFriendRepository(provider: dependencies.provider)
        return FriendAddViewModel(
            followUseCase: DefaultFollowFriendUseCase(repository: repository),
            searchUseCase: DefaultSearchFriendUseCase(repository: repository),
            actions: actions,
            userInfoManager: dependencies.userInfoManager)
    }
    
    func makeSocialDetailViewController(actions: SocialDetailViewModelActions, friend: Friend) -> UIViewController {
        return SocialDetailViewController(viewModel: makeSocialDetailViewModel(actions: actions, friend: friend))
    }
    
    private func makeSocialDetailViewModel(actions: SocialDetailViewModelActions, friend: Friend) -> SocialDetailViewModel {
        let repository = DefaultFriendRepository(provider: dependencies.provider)
        return SocialDetailViewModel(
            friend: friend,
            loadChartUseCase: DefaultLoadChartUseCase(repository: repository),
            unfollowUseCase: DefaultUnfollowFriendUseCase(repository: repository),
            actions: actions)
    }
    
    func makeMyPageDIContainer() -> MyPageDIContainer {
        return MyPageDIContainer(
            dependencies: MyPageDIContainer.Dependencies(
                provider: dependencies.provider,
                userInfoManager: dependencies.userInfoManager)
        )
    }
}
