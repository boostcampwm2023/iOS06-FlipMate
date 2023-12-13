//
//  TimerFlowCoordinator.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/25.
//

import UIKit

protocol TimerFlowCoordinatorDependencies {
    func makeTimerViewController(actions: TimerViewModelActions) -> TimerViewController
    func makeCategoryDIContainer() -> CategoryDIContainer
    func makeTimerFinishViewController(actions: TimerFinishViewModelActions, studyEndLog: StudyEndLog) -> UIViewController
}

final class TimerFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private weak var navigationController: UINavigationController?
    private weak var timerViewController: TimerViewController?
    private let dependencies: TimerFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: TimerFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = TimerViewModelActions(
            showCategorySettingViewController: showCategorySettingViewController,
            showTimerFinishViewController: showTimerFinishViewController)
        let viewController = dependencies.makeTimerViewController(actions: actions)
        timerViewController = viewController
        navigationController?.viewControllers = [viewController]
    }
    
    private func showCategorySettingViewController() {
        let categoryDIContainer = dependencies.makeCategoryDIContainer()
        let coordinator = categoryDIContainer.makeCategoryFlowCoordinator(
            navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    private func showTimerFinishViewController(studyEndLog: StudyEndLog) {
        let actions = TimerFinishViewModelActions(
            didSaveStudyEndLog: didSaveStudyEndLog,
            didCancleStudyEndLog: didCancleStudyEndLog)
        let timerFinishViewController = dependencies.makeTimerFinishViewController(actions: actions, studyEndLog: studyEndLog)
        timerFinishViewController.modalPresentationStyle = .overFullScreen
        timerFinishViewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(timerFinishViewController, animated: true)
    }
    
    private func didSaveStudyEndLog() {
        navigationController?.dismiss(animated: true)
        timerViewController?.saveStudyLog()
    }
    
    private func didCancleStudyEndLog() {
        navigationController?.dismiss(animated: true)
    }
}
