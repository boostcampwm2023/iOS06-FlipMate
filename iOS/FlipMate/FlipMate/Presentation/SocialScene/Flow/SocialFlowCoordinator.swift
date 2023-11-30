//
//  SocialFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import UIKit

final class SocialDIContainer: SocialFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
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
    
    func makeSocialViewController() -> UIViewController {
        return SocialViewController()
    }
    
    func makeFriendAddViewControlleR() -> UIViewController {
        return FriendAddViewController(viewModel: FriendAddViewModel(
            myNickname: "test",
            friendUseCase: DefaultFriendUseCase(
                repository: DefaultFriendRepository(
                    provider: dependencies.provider))
            )
        )
    }
}

