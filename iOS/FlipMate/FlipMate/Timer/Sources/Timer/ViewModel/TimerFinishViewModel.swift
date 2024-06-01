//
//  TimerFinishViewModel.swift
//
//
//  Created by 권승용 on 5/30/24.
//

import Foundation
import Combine

import Domain
import Core

public struct TimerFinishViewModelActions {
    let didSaveStudyEndLog: () -> Void
    let didCancleStudyEndLog: () -> Void
    
    public init(didSaveStudyEndLog: @escaping () -> Void, didCancleStudyEndLog: @escaping () -> Void) {
        self.didSaveStudyEndLog = didSaveStudyEndLog
        self.didCancleStudyEndLog = didCancleStudyEndLog
    }
}

public protocol TimerFinishViewModelInput {
    func saveButtonDidTapped()
    func cancleButtonDidTapped()
}

public protocol TimerFinishViewModelOutput {
    var learningTimePublisher: AnyPublisher<Int, Never> { get }
}

public typealias TimerFinishViewModelProtocol = TimerFinishViewModelInput & TimerFinishViewModelOutput

public struct StudyEndLog {
    let learningTime: Int
    let endDate: Date
    let categoryId: Int?
}

public final class TimerFinishViewModel: TimerFinishViewModelProtocol {
    
    private let studyEndLog: StudyEndLog
    private let finishTimerUseCase: FinishTimerUseCase
    private let actions: TimerFinishViewModelActions?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subject
    private lazy var learningTimeSubject = CurrentValueSubject<Int, Never>(studyEndLog.learningTime)
    
    public init(studyEndLog: StudyEndLog, finishTimerUseCase: FinishTimerUseCase, actions: TimerFinishViewModelActions? = nil) {
        self.studyEndLog = studyEndLog
        self.finishTimerUseCase = finishTimerUseCase
        self.actions = actions
    }
    
    // MARK: - output
    public var learningTimePublisher: AnyPublisher<Int, Never> {
        return learningTimeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - input
    public func saveButtonDidTapped() {
        finishTimerUseCase.finishTimer(
            endTime: studyEndLog.endDate,
            learningTime: studyEndLog.learningTime,
            categoryId: studyEndLog.categoryId)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                FMLogger.timer.debug("공부 종료 API 요청 성공")
            case .failure(let error):
                FMLogger.timer.error("\(error.localizedDescription)")
            }
        } receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.actions?.didSaveStudyEndLog()
        }
        .store(in: &cancellables)
    }
    
    public func cancleButtonDidTapped() {
        finishTimerUseCase.finishTimer(
            endTime: studyEndLog.endDate,
            learningTime: 0,
            categoryId: studyEndLog.categoryId)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                FMLogger.timer.debug("공부 종료 API 요청 성공")
            case .failure(let error):
                FMLogger.timer.error("\(error.localizedDescription)")
            }
        } receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.actions?.didCancleStudyEndLog()
        }
        .store(in: &cancellables)
    }
}
