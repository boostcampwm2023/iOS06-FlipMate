//
//  TimerSceneDIContainer.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit
import Network

final class TimerSceneDIContainer: TimerFlowCoordinatorDependencies {
    struct Dependencies {
        let provider: Providable
        let categoryManager: CategoryManageable
        let userInfoManager: UserInfoManageable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTimerViewController(actions: TimerViewModelActions) -> TimerViewController {
        return TimerViewController(
            timerViewModel: makeTimerViewModel(actions: actions))
    }
    
    func makeTimerFinishViewController(actions: TimerFinishViewModelActions, studyEndLog: StudyEndLog) -> UIViewController {
        return TimerFinishViewController(
            viewModel: makeTimerFinishViewModel(studyEndLog: studyEndLog, actions: actions))
    }
    
    func makeTimerFinishViewModel(studyEndLog: StudyEndLog, actions: TimerFinishViewModelActions) -> TimerFinishViewModel {
        return TimerFinishViewModel(
            studyEndLog: studyEndLog,
            finishTimerUseCase: makeFinishTimerUseCase(),
            actions: actions)
    }
    
    func makeTimerViewModel(actions: TimerViewModelActions) -> TimerViewModelProtocol {
        return TimerViewModel(
            startTimerUseCase: makeStartTimerUseCase(),
            getStudyLogUseCase: makeGetStudyLogUseCase(),
            getUserInfoUseCase: makeGetUserInfoUseCase(),
            studingPingUseCase: makeStudingPingUseCase(),
            patchTimeZoneUseCase: makePatchTimeZoneUseCase(),
            actions: actions,
            categoryManager: dependencies.categoryManager,
            userInfoManager: dependencies.userInfoManager,
            timerManager: TimerManager())
    }
    
    func makeStartTimerUseCase() -> StartTimerUseCase {
        return DefaultStartTimerUseCase(timerRepository: makeTimerRepository())
    }
    
    func makeFinishTimerUseCase() -> FinishTimerUseCase {
        return DefaultFinishTimerUseCase(timerRepository: makeTimerRepository())
    }
    
    func makeGetStudyLogUseCase() -> GetStudyLogUseCase {
        return DefaultGetStudyLogUseCase(studyLogRepository: makeStudyLogRespository())
    }
    
    func makeGetUserInfoUseCase() -> GetUserInfoUseCase {
        return DefaultGetUserInfoUseCase(repository: makeUserInfoRepository())
    }
    
    func makeStudingPingUseCase() -> StudingPingUseCase {
        return DefaultStudingPingUseCase(repository: makeStudyLogRespository())
    }
    
    func makePatchTimeZoneUseCase() -> PatchTimeZoneUseCase {
        return DefaultPatchTimeZoneUseCase(repository: makeUserInfoRepository())
    }
    
    func makeTimerRepository() -> TimerRepsoitory {
        return DefaultTimerRepository(provider: dependencies.provider)
    }
    
    func makeStudyLogRespository() -> StudyLogRepository {
        return DefaultStudyLogRepository(provider: dependencies.provider)
    }
    
    func makeUserInfoRepository() -> UserInfoRepository {
        return DefaultUserInfoRepository(provider: dependencies.provider)
    }
    
    func makeTimerFlowCoordinator(navigationController: UINavigationController) -> TimerFlowCoordinator {
        return TimerFlowCoordinator(
            navigationController: navigationController,
            dependencies: self)
    }
    
    // MARK: - Category Setting
    func makeCategoryDIContainer() -> CategoryDIContainer {
        let dependencies = CategoryDIContainer.Dependencies(
            provider: dependencies.provider,
            categoryManager: dependencies.categoryManager)
        return CategoryDIContainer(dependencies: dependencies)
    }
}
