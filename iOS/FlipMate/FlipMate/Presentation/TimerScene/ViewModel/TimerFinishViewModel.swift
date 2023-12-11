//
//  TimerFinishViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/27.
//

import Foundation
import Combine

struct TimerFinishViewModelActions {
    let didSaveStudyEndLog: (StudyEndLog) -> Void
    let didCancleStudyEndLog: () -> Void
}

protocol TimerFinishViewModelInput {
    func saveButtonDidTapped()
    func cancleButtonDidTapped()
}

protocol TimerFinishViewModelOutput {
    var learningTimePublisher: AnyPublisher<Int, Never> { get }
}

typealias TimerFinishViewModelProtocol = TimerFinishViewModelInput & TimerFinishViewModelOutput

struct StudyEndLog {
    let learningTime: Int
    let endDate: Date
    let categoryId: Int?
}

final class TimerFinishViewModel: TimerFinishViewModelProtocol {
    
    private let studyEndLog: StudyEndLog
    private let timerFinishUseCase: TimerFinishUseCase
    private let actions: TimerFinishViewModelActions?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subject
    private lazy var learningTimeSubject = CurrentValueSubject<Int, Never>(studyEndLog.learningTime)
    
    init(studyEndLog: StudyEndLog, timerFinishUseCase: TimerFinishUseCase, actions: TimerFinishViewModelActions? = nil) {
        self.studyEndLog = studyEndLog
        self.timerFinishUseCase = timerFinishUseCase
        self.actions = actions
    }
    
    // MARK: - output
    var learningTimePublisher: AnyPublisher<Int, Never> {
        return learningTimeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - input
    func saveButtonDidTapped() {
        timerFinishUseCase.finishTimer(endTime: studyEndLog.endDate, learningTime: studyEndLog.learningTime, categoryId: studyEndLog.categoryId)
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
                self.actions?.didSaveStudyEndLog(studyEndLog)
            }
            .store(in: &cancellables)
    }
    
    func cancleButtonDidTapped() {
        timerFinishUseCase.finishTimer(endTime: studyEndLog.endDate, learningTime: 0, categoryId: studyEndLog.categoryId)
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
