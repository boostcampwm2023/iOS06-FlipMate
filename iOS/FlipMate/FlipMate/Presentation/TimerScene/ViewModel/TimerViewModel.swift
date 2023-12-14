//
//  TimerViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/14.
//

import Foundation
import Combine
import OSLog

enum TimerState {
    case suspended // 타이머 일시정지 상태
    case resumed // 타이머 작동 상태
    case cancled // 타이머 종료 상태
    case notStarted // 타이머 시작안된 상태
}

struct TimerViewModelActions {
    let showCategorySettingViewController: () -> Void
    let showTimerFinishViewController: (StudyEndLog) -> Void
}

protocol TimerViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDisappear()
    func deviceOrientationDidChange(_ sender: DeviceOrientation)
    func deviceProximityDidChange(_ sender: Bool)
    func categorySettingButtoneDidTapped()
    func categoryDidSelected(category: Category)
    func categoryDidDeselected()
    func refreshStudyLog()
}

protocol TimerViewModelOutput {
    var isDeviceFaceDownPublisher: AnyPublisher<Bool, Never> { get }
    var totalTimePublisher: AnyPublisher<Int, Never> { get }
    var categoryChangePublisher: AnyPublisher<Category, Never> { get }
    var categoriesPublisher: AnyPublisher<[Category], Never> { get }
    var deviceSettingEnabledPublisher: AnyPublisher<Bool, Never> { get }
}

typealias TimerViewModelProtocol = TimerViewModelInput & TimerViewModelOutput

final class TimerViewModel: TimerViewModelProtocol {
    // MARK: UseCase
    private var timerUseCase: TimerUseCase
    private var studyLogUseCase: StudyLogUseCase
    private var studingPingUseCase: StudingPingUseCase
    private var userInfoUseCase: UserInfoUseCase
    private var timeZoneUseCase: TimeZoneUseCase
    
    // MARK: Subject
    private var isDeviceFaceDownSubject = PassthroughSubject<Bool, Never>()
    private var isPresentingCategorySubject = PassthroughSubject<Void, Never>()
    private var categoryChangeSubject = PassthroughSubject<Category, Never>()
    private var categoriesSubject = PassthroughSubject<[Category], Never>()
    private var deviceSettingEnabledSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: Properties
    private var proximity: Bool?
    private var orientation: DeviceOrientation = .unknown
    private var cancellables = Set<AnyCancellable>()
    private var increaseTime: Int = -1
    private var selectedCategory: Category?
    private let actions: TimerViewModelActions?
    
    // MARK: - Managers
    private let categoryManager: CategoryManageable
    private let timerManager: TimerManagerProtocol
    private let userInfoManager: UserInfoManagerProtocol
    
    // MARK: - init
    init(timerUseCase: TimerUseCase,
         studyLogUseCase: StudyLogUseCase,
         studingPingUseCase: StudingPingUseCase,
         userInfoUseCase: UserInfoUseCase,
         timeZoneUseCase: TimeZoneUseCase,
         actions: TimerViewModelActions? = nil,
         categoryManager: CategoryManageable,
         userInfoManager: UserInfoManagerProtocol,
         timerManager: TimerManagerProtocol) {
        self.timerUseCase = timerUseCase
        self.studyLogUseCase = studyLogUseCase
        self.studingPingUseCase = studingPingUseCase
        self.userInfoUseCase = userInfoUseCase
        self.timeZoneUseCase = timeZoneUseCase
        self.actions = actions
        self.categoryManager = categoryManager
        self.userInfoManager = userInfoManager
        self.timerManager = timerManager
    }
    
    // MARK: Output
    var isDeviceFaceDownPublisher: AnyPublisher<Bool, Never> {
        return isDeviceFaceDownSubject.eraseToAnyPublisher()
    }
    
    var isPresentingCategoryPublisher: AnyPublisher<Void, Never> {
        return isPresentingCategorySubject.eraseToAnyPublisher()
    }
    
    var totalTimePublisher: AnyPublisher<Int, Never> {
        return userInfoManager.totalTimeChangePublihser
    }
    
    var categoryChangePublisher: AnyPublisher<Category, Never> {
        return categoryChangeSubject.eraseToAnyPublisher()
    }
    
    var categoriesPublisher: AnyPublisher<[Category], Never> {
        return categoryManager.categoryDidChangePublisher
    }
    
    var deviceSettingEnabledPublisher: AnyPublisher<Bool, Never> {
        return deviceSettingEnabledSubject.eraseToAnyPublisher()
    }
    
    // MARK: Input
    func deviceOrientationDidChange(_ sender: DeviceOrientation) {
        orientation = sender
        sendFaceDownStatus()
    }
    
    func deviceProximityDidChange(_ sender: Bool) {
        proximity = sender
        sendFaceDownStatus()
    }
    
    func categorySettingButtoneDidTapped() {
        actions?.showCategorySettingViewController()
    }
    
    func viewDidLoad() {
        updateStudyLog()
        updateUserInfo()
        patchTimeZone()
    }
    
    func viewWillAppear() {
        deviceSettingEnabledSubject.send(true)
    }
    
    func viewDidDisappear() {
        deviceSettingEnabledSubject.send(false)
    }
    
    func categoryDidSelected(category: Category) {
        FMLogger.timer.debug("\(category.subject)가 선택되었습니다.")
        selectedCategory = category
    }
    
    func categoryDidDeselected() {
        FMLogger.timer.debug("선택된 카테고리가 해제되었습니다.")
        selectedCategory = nil
    }
    
    func refreshStudyLog() {
        updateStudyLog()
    }
}

// MARK: Private Methods
private extension TimerViewModel {
    
    /// 화면이 뒤집어져있는지 판단해 그 결과를 Output으로 전달합니다
    func sendFaceDownStatus() {
        if orientation == DeviceOrientation.faceDown && proximity == true {
            FMLogger.user.debug("디바이스가 face down 상태입니다.")
            isDeviceFaceDownSubject.send(true)
            startTimer()
        } else {
            guard timerManager.state == .resumed else { return }
            FMLogger.user.debug("디바이스가 face up 상태입니다.")
            isDeviceFaceDownSubject.send(false)
            stopTimer()
        }
    }
    
    func changeCategory(category: Category) {
        categoryManager.change(category: category)
    }
    
    func updateStudyLog() {
        studyLogUseCase.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { complection in
                switch complection {
                case .finished:
                    FMLogger.timer.debug("유저 공부 정보 요청 성공")
                case .failure(let error):
                    FMLogger.timer.error("유저 공부 정보 요청 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] studyLog in
                guard let self = self else { return }
                self.userInfoManager.updateTotalTime(at: studyLog.totalTime)
                self.categoryManager.replace(categories: studyLog.category)
            }
            .store(in: &cancellables)
    }
    
    func updateUserInfo() {
        userInfoUseCase.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.user.debug("유저 정보 요청 성공")
                case .failure(let error):
                    FMLogger.user.error("유저 정보 요청 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] userInfo in
                guard let self = self else { return }
                self.userInfoManager.updateNickname(at: userInfo.name)
                self.userInfoManager.updateProfileImage(at: userInfo.profileImageURL)
            }
            .store(in: &cancellables)
    }
    
    func patchTimeZone() {
        Task {
            try await timeZoneUseCase.patchTimeZone(date: Date())
        }
    }
}

// MARK: - Timer
private extension TimerViewModel {
    /// 타이머 시작
    func startTimer() {
        let categoryId = selectedCategory?.id
        timerUseCase.startTimer(startTime: Date(), categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.timer.debug("공부 시작 API 요청 성공")
                    return
                case .failure(let error):
                    // TODO: 타이머 일시정지 후 타이머 작동 이전 시간으로 롤백
                    FMLogger.timer.error("\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.increaseTime = -1
                self.timerManager.start(completion: increaseTotalTime)
            }
            .store(in: &cancellables)
    }
    
    func stopTimer() {
        timerManager.cancel()
        let studyEndLog = StudyEndLog(learningTime: increaseTime, endDate: Date(), categoryId: selectedCategory?.id)
        deviceSettingEnabledSubject.send(false)
        actions?.showTimerFinishViewController(studyEndLog)
    }
    
    func increaseTotalTime() {
        increaseTime += 1
        
        if increaseTime % 8 == 0 {
            Task {
                try await studingPingUseCase.studingPing()
            }
        }
        
        FMLogger.timer.debug("경과 시간 \(self.increaseTime)")
    }
}
