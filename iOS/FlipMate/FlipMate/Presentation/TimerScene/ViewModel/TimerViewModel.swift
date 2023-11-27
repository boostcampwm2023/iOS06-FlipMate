//
//  TimerViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/14.
//

import Foundation
import Combine
import OSLog


struct TimerViewModelActions {
    let showCategorySettingViewController: () -> Void
}

protocol TimerViewModelInput {
    func viewDidLoad()
    func deviceOrientationDidChange(_ sender: DeviceOrientation)
    func deviceProximityDidChange(_ sender: Bool)
    func categorySettingButtoneDidTapped()
    func categoryDidSelected(category: Category)
}

protocol TimerViewModelOutput {
    var isDeviceFaceDownPublisher: AnyPublisher<Bool, Never> { get }
    var totalTimePublisher: AnyPublisher<Int, Never> { get }
    var categoryChangePublisher: AnyPublisher<[Category], Never> { get }
    var categoriesPublisher: AnyPublisher<[Category], Never> { get }
}

typealias TimerViewModelProtocol = TimerViewModelInput & TimerViewModelOutput

final class TimerViewModel: TimerViewModelProtocol {
    // MARK: UseCase
    private var timerUseCase: TimerUseCase
    private var userInfoUserCase: StudyLogUseCase
    
    // MARK: Subject
    private var isDeviceFaceDownSubject = PassthroughSubject<Bool, Never>()
    private var isPresentingCategorySubject = PassthroughSubject<Void, Never>()
    private var totalTimeSubject = PassthroughSubject<Int, Never>()
    private var categoryChangeSubject = PassthroughSubject<[Category], Never>()
    private var categoriesSubject = PassthroughSubject<[Category], Never>()

    // MARK: Properties
    private var proximity: Bool?
    private var orientation: DeviceOrientation = .unknown
    private var timerState: TimerState = .notStarted
    private var cancellables = Set<AnyCancellable>()
    private var totalTime: Int = 0 // 총 공부 시간
    private var categories = [Category]()
    private var selectedCategory: Category?
    private let actions: TimerViewModelActions?
    
    // MARK: - init
    init(timerUseCase: TimerUseCase, userInfoUserCase: StudyLogUseCase, actions: TimerViewModelActions? = nil) {
        self.timerUseCase = timerUseCase
        self.userInfoUserCase = userInfoUserCase
        self.actions = actions
    }
    
    // MARK: Output
    var isDeviceFaceDownPublisher: AnyPublisher<Bool, Never> {
        return isDeviceFaceDownSubject.eraseToAnyPublisher()
    }
    
    var isPresentingCategoryPublisher: AnyPublisher<Void, Never> {
        return isPresentingCategorySubject.eraseToAnyPublisher()
    }
    
    var totalTimePublisher: AnyPublisher<Int, Never> {
        return totalTimeSubject.eraseToAnyPublisher()
    }
    
    var categoryChangePublisher: AnyPublisher<[Category], Never> {
        return categoryChangeSubject.eraseToAnyPublisher()
    }
    
    var categoriesPublisher: AnyPublisher<[Category], Never> {
        return categoriesSubject.eraseToAnyPublisher()
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
        userInfoUserCase.getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { complection in
                switch complection {
                case .finished:
                    FMLogger.timer.debug("유저 정보 요청 성공")
                case .failure(let error):
                    FMLogger.timer.error("유저 정보 요청 실패 \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] userInfo in
                guard let self = self else { return }
                self.totalTimeDidChange(time: userInfo.totalTime)
                self.categoriesDidChange(categories: userInfo.category)
            }
            .store(in: &cancellables)
    }
    
    func categoryDidSelected(category: Category) {
        FMLogger.timer.debug("\(category.subject)가 선택되었습니다.")
        selectedCategory = category
    }
}

// MARK: Private Methods
private extension TimerViewModel {
    
    /// 화면이 뒤집어져있는지 판단해 그 결과를 Output으로 전달합니다
    func sendFaceDownStatus() {
        if orientation == DeviceOrientation.faceDown && proximity == true {
            FMLogger.user.debug("디바이스가 face down 상태입니다.")
            isDeviceFaceDownSubject.send(true)
            if timerState == .notStarted {
                startTimer()
            } else {
                resumeTimer()
            }
        } else {
            guard timerState == .resumed else { return }
            
            FMLogger.user.debug("디바이스가 face up 상태입니다.")
            isDeviceFaceDownSubject.send(false)
            suspendTimer()
        }
    }
    
    func totalTimeDidChange(time: Int) {
        totalTime += time
        totalTimeSubject.send(totalTime)
    }
    
    func categoriesDidChange(categories: [Category]) {
        self.categories = categories
        categoriesSubject.send(categories)
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
                self.timerState = .resumed
            }
            .store(in: &cancellables)
    }
    
    /// 타이머 재시작
    func resumeTimer() {
        let categoryId = selectedCategory?.id
        timerUseCase.resumeTimer(resumeTime: Date(), categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.timer.debug("공부 재시작 API 요청 성공")
                    return
                case .failure(let error):
                    // TODO: 타이머 일시정지 후 타이머 작동 이전 시간으로 롤백
                    FMLogger.timer.error("\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.timerState = .resumed
            }
            .store(in: &cancellables)
    }
    
    /// 타이머 일시정지
    func suspendTimer() {
        let categoryId = selectedCategory?.id
        timerUseCase.suspendTimer(suspendTime: Date(), categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.timer.debug("공부 종료 API 요청 성공")
                    return
                case .failure(let error):
                    FMLogger.timer.error("\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] learningTime in
                guard let self = self else { return }
                self.timerState = .suspended
                self.totalTime += learningTime
                self.totalTimeSubject.send(self.totalTime)
                guard let selectedCategory = selectedCategory,
                      let categoryStudyTime = selectedCategory.studyTime,
                      let categoryIndex = self.categories.firstIndex(of: selectedCategory) else { return }
            
                let newCategory = Category(
                    id: selectedCategory.id, 
                    color: selectedCategory.color,
                    subject: selectedCategory.subject, 
                    studyTime: categoryStudyTime + learningTime)
                
                categories[categoryIndex] = newCategory
                categoryChangeSubject.send(categories)
                self.selectedCategory = nil
            }
            .store(in: &cancellables)
    }
    
    /// 타이머 종료
    func stopTimer() {
        timerUseCase.stopTimer()
    }
}

private extension TimerViewModel {
    enum TimerState {
        case suspended // 타이머 일시정지 상태
        case resumed // 타이머 작동 상태
        case cancled // 타이머 종료 상태
        case notStarted // 타이머 시작안된 상태
    }
}
