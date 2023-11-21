//
//  TimerViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/14.
//

import Foundation
import Combine
import OSLog

protocol TimerViewModelInput {
    func deviceOrientationDidChange(_ sender: DeviceOrientation)
    func deviceProximityDidChange(_ sender: Bool)
    func categorySettingButtoneDidTapped()
}

protocol TimerViewModelOutput {
    var isDeviceFaceDownPublisher: AnyPublisher<Bool, Never> { get }
    var isPresentingCategoryPublisher: AnyPublisher<Void, Never> { get }
    var totalTimePublisher: AnyPublisher<Int, Never> { get }
}

typealias TimerViewModelProtocol = TimerViewModelInput & TimerViewModelOutput

final class TimerViewModel: TimerViewModelProtocol {
    
    // MARK: Properties
    private var orientation: DeviceOrientation = .unknown
    private var proximity: Bool?
    private var isDeviceFaceDownSubject = PassthroughSubject<Bool, Never>()
    private var isPresentingCategorySubject = PassthroughSubject<Void, Never>()
    private var totalTimeSubject = PassthroughSubject<Int, Never>()
    private var timerUseCase: TimerUseCase
    private var isSuspendedTimer: Bool = false
    private var timerState: TimerState = .stopped
    
    // MARK: - init
    init(timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
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
        isPresentingCategorySubject.send(Void())
    }
}

// MARK: Private Methods
private extension TimerViewModel {
    
    /// 화면이 뒤집어져있는지 판단해 그 결과를 Output으로 전달합니다
    func sendFaceDownStatus() {
        if orientation == DeviceOrientation.faceDown && proximity == true {
            FMLogger.user.debug("디바이스가 face down 상태입니다.")
            isDeviceFaceDownSubject.send(true)
            
            if isSuspendedTimer {
                timerUseCase.resumeTimer(resumeTime: Date())
            } else {
                timerUseCase.startTimer(startTime: Date())
                isSuspendedTimer = true
            }
            timerState = .counting
        } else {
            FMLogger.user.debug("디바이스가 face up 상태입니다.")
            
            guard timerState == .counting else { return }
            isDeviceFaceDownSubject.send(false)
            let time = timerUseCase.suspendTimer()
            totalTimeSubject.send(time)
            timerState = .stopped
        }
    }
}

private extension TimerViewModel {
    enum TimerState {
        case counting, stopped
    }
}
