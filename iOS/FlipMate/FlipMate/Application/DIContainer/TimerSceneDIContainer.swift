//
//  TimerSceneDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

final class TimerSceneDIContainer: TimerFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
        let categoryManager: CategoryManager
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTimerViewController() -> TimerViewController {
        return TimerViewController(
            timerViewModel: makeTimerViewModel())
    }
    
    func makeTimerViewModel() -> TimerViewModelProtocol {
        return TimerViewModel(
            timerUseCase: makeTimerUseCase(),
            userInfoUserCase: makeUserInfoUseCase())
    }
    
    func makeTimerUseCase() -> TimerUseCase {
        return DefaultTimerUseCase(timerRepository: makeTimerRepository())
    }
    
    func makeUserInfoUseCase() -> StudyLogUseCase {
        return DefaultStudyLogUseCase(userInfoRepository: makeUserInfoRespository())
    }
    
    func makeTimerRepository() -> TimerRepsoitory {
        return DefaultTimerRepository(provider: dependencies.provider)
    }
    
    func makeUserInfoRespository() -> StudyLogRepository {
        return DefaultStudyLogRepository(provider: dependencies.provider)
    }
    
    func makeTimerFlowCoordinator(navigationController: UINavigationController) -> TimerFlowCoordinator {
        return TimerFlowCoordinator(
            navigationController: navigationController,
            dependencies: self)
    }
}
